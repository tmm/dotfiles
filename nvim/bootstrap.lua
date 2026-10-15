-- Run with: nvim --headless -u NONE -l nvim/bootstrap.lua plugins|tools
local function run()
  vim.g.dotfiles_bootstrap = true
  vim.o.loadplugins = true
  local config_dir = vim.fn.stdpath("config")
  local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
  local lock_lines = vim.fn.readfile(config_dir .. "/lazy-lock.json")
  local lock = vim.json.decode(table.concat(lock_lines, "\n"))

  local function git(args)
    local result = vim.system(vim.list_extend({ "git" }, args), { text = true }):wait(120000)
    assert(result.code == 0, result.stderr)
    return vim.trim(result.stdout)
  end

  local lazy_dir = plugin_dir .. "/lazy.nvim"
  if not vim.uv.fs_stat(lazy_dir) then
    git({ "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazy_dir })
  end
  if git({ "-C", lazy_dir, "rev-parse", "HEAD" }) ~= lock["lazy.nvim"].commit then
    git({ "-C", lazy_dir, "diff", "--exit-code", "HEAD" })
    git({ "-C", lazy_dir, "fetch", "origin", lock["lazy.nvim"].commit })
    git({ "-C", lazy_dir, "checkout", "--detach", lock["lazy.nvim"].commit })
  end

  -- Lazy may rewrite its lockfile. Never change the checked-in lock during setup.
  vim.fn.mkdir(vim.fn.stdpath("state"), "p")
  vim.fn.writefile(lock_lines, vim.fn.stdpath("state") .. "/bootstrap-lock.json")
  dofile(config_dir .. "/init.lua")
  local lazy = require("lazy")
  local plugins = require("lazy.core.config").plugins

  if arg[1] == "plugins" then
    local restore = {}
    for name, entry in pairs(lock) do
      assert(plugins[name], "Locked plugin missing from spec: " .. name)
      if git({ "-C", plugins[name].dir, "rev-parse", "HEAD" }) ~= entry.commit then
        git({ "-C", plugins[name].dir, "diff", "--exit-code", "HEAD" })
        restore[#restore + 1] = name
      end
    end
    if #restore > 0 then
      lazy.restore({ plugins = restore, wait = true, show = false })
    end
    for name, entry in pairs(lock) do
      assert(git({ "-C", plugins[name].dir, "rev-parse", "HEAD" }) == entry.commit, name .. " is not locked")
    end
    io.stdout:write("Verified " .. vim.tbl_count(lock) .. " locked plugins\n")
  elseif arg[1] == "tools" then
    local opts = require("util.init").opts
    lazy.load({ plugins = { "mason.nvim", "nvim-treesitter" } })
    local registry = require("mason-registry")
    local refreshed, refresh_error = registry.refresh()
    assert(refreshed, vim.inspect(refresh_error))

    local tools = {}
    for _, name in ipairs(opts("mason.nvim").ensure_installed) do
      tools[name] = true
    end
    local mappings = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package
    for server, settings in pairs(opts("nvim-lspconfig").servers) do
      if type(settings) == "table" and settings.enabled ~= false and settings.mason ~= false and mappings[server] then
        tools[mappings[server]] = true
      end
    end

    local pending, failures = 0, {}
    for name in pairs(tools) do
      local package = registry.get_package(name)
      if not package:is_installed() then
        pending = pending + 1
        package:install({}, function(ok, result)
          if not ok then
            failures[#failures + 1] = name .. ": " .. vim.inspect(result)
          end
          pending = pending - 1
        end)
      end
    end

    local parsers = opts("nvim-treesitter").ensure_installed
    local treesitter = require("nvim-treesitter")
    assert(treesitter.install(parsers):wait(300000), "Parser installation failed")
    assert(treesitter.update(parsers):wait(300000), "Parser update failed")
    -- Lazy drops nonexistent runtime directories; restore the newly created parser site.
    vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
    for _, parser in ipairs(parsers) do
      local loaded, reason = vim.treesitter.language.add(parser)
      assert(loaded, reason)
    end
    assert(
      vim.wait(300000, function()
        return pending == 0
      end, 50),
      "Mason installation timed out"
    )
    assert(#failures == 0, table.concat(failures, "\n"))
    for name in pairs(tools) do
      assert(registry.get_package(name):is_installed(), "Missing tool: " .. name)
    end

    lazy.load({ plugins = { "blink.cmp" } })
    assert(
      vim.wait(120000, function()
        return package.loaded.blink_cmp_fuzzy ~= nil
      end, 50),
      "Blink native completion library did not load"
    )
    io.stdout:write("Verified " .. #parsers .. " parsers and " .. vim.tbl_count(tools) .. " Mason tools\n")
  else
    error("Expected plugins or tools phase")
  end

  for name, plugin in pairs(plugins) do
    assert(not require("lazy.core.plugin").has_errors(plugin), "Plugin setup failed: " .. name)
  end
  assert(vim.v.errmsg == "", vim.v.errmsg)
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
  io.stderr:write(tostring(err), "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
