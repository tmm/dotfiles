require("config.options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  change_detection = {
    enabled = true,
    notify = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = "~/Developer",
  },
  install = { colorscheme = { "rsms" } },
  spec = {
    { import = "plugins" },
  },
})

-- delay notifications till vim.notify was replaced or after 500ms
require("util.init").lazy_notify()

local group = vim.api.nvim_create_augroup("TmmVim", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
    require("config.autocmds")

    require("util.format").setup()
    require("util.root").setup()
  end,
})
