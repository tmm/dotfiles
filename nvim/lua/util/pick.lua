local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

function M.open(command, opts)
  return function()
    opts = opts or {}

    if type(opts.cwd) == "boolean" then
      require("util.init").warn("pick: opts.cwd should be a string or nil")
      opts.cwd = nil
    end

    if not opts.cwd and opts.root ~= false then
      opts.cwd = require("util.root").get({ buf = opts.buf })
    end

    require("snacks").picker.pick(command, opts)
  end
end

function M.wrap(command, opts)
  opts = opts or {}
  return function()
    M.open(command, vim.deepcopy(opts))
  end
end

function M.config_files()
  return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M
