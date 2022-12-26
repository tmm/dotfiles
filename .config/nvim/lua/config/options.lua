local indent = 2

vim.g.mapleader = " "

vim.opt.autoindent     = true -- Good auto indent
vim.opt.clipboard      = 'unnamed,unnamedplus' -- Use clipboard for all operations
vim.opt.cursorline     = true -- Highlight current line
vim.opt.expandtab      = true -- Expand tabs into spaces
vim.opt.hidden         = true -- Handle multiple buffers better
vim.opt.mouse          = '' -- Disable mouse
vim.opt.number         = true -- Show line numbers
vim.opt.relativenumber = true -- Line numbers relative to cursor
vim.opt.scrolloff      = 4 -- Always show at least four lines above/below cursor
vim.opt.shiftround     = true -- Round indent
vim.opt.shiftwidth     = indent -- Size of an indent
vim.opt.shortmess      = 'Iac' -- Disable start up message and abbreviate items
vim.opt.showbreak      = '↪'
vim.opt.showmode       = false -- Hide redundant mode
vim.opt.sidescrolloff  = 4 -- Always show at least four columns left/right cursor
vim.opt.signcolumn     = 'yes' -- Always show the signcolumn
vim.opt.smartcase      = true -- Switch to case-sensitive search for capital letters
vim.opt.smartindent    = true
vim.opt.splitbelow     = true -- Put new windows below current
vim.opt.splitright     = true -- Put new windows right of current
vim.opt.swapfile       = false -- Disable swapfiles
vim.opt.tabstop        = indent -- Number of spaces tabs count for
vim.opt.termguicolors  = true -- Support for true color (https://github.com/termstandard/colors)
vim.opt.title          = true -- Set terminal title
vim.opt.undodir        = vim.env.XDG_CONFIG_HOME .. '/nvim/undo'
vim.opt.undofile       = true
vim.opt.updatetime     = 200 -- Faster update time
vim.opt.visualbell     = true -- Disable beeping
vim.opt.wildmode       = 'longest:full,full' -- Completion settings

-- When using fish, set shell to bash
if vim.env.SHELL:match('fish$') then
  vim.opt.shell = '/bin/bash'
end

-- Use proper syntax highlighting in code blocks
local fences = {
  "console=sh",
  "javascript",
  "js=javascript",
  "json",
  "lua",
  "python",
  "sh",
  "shell=sh",
  "ts=typescript",
  "typescript",
}
vim.g.markdown_fenced_languages = fences
vim.g.markdown_recommended_style = 0
