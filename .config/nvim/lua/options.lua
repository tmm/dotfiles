local set = vim.opt

set.autoindent     = true -- Good auto indent
set.clipboard      = 'unnamed,unnamedplus' -- Use clipboard for all operations
set.cursorline     = true -- Highlight current line
set.expandtab      = true -- Expand tabs into spaces
set.foldmethod     = 'syntax'
set.foldlevelstart = 4 -- Some folds closed
set.hidden         = true -- Handle multiple buffers better
set.number         = true -- Show line numbers
set.relativenumber = true -- Line numbers relative to cursor
set.scrolloff      = 4 -- Always show at least four lines above/below cursor
set.shortmess      = 'Iac' -- Disable start up message and abbreviate items
set.showbreak      = '↪'
set.showmode       = false -- Hide redundant mode
set.sidescrolloff  = 4 -- Always show at least four columns left/right cursor
set.signcolumn     = 'yes' -- Always show the signcolumn
set.smartcase      = true -- Switch to case-sensitive search for capital letters
set.smartindent    = true
set.splitbelow     = true -- More natural split opening
set.splitright     = true
set.swapfile       = false -- Disable swapfiles
set.termguicolors  = true -- Support for true color (https://github.com/termstandard/colors)
set.title          = true -- Set terminal title
set.undodir        = vim.env.XDG_CONFIG_HOME .. '/nvim/undo'
set.undofile       = true
set.updatetime     = 100 -- Faster update time
set.visualbell     = true -- Disable beeping
set.wildmode       = 'longest:full,full' -- Completion settings

-- When using fish, set shell to bash
if vim.env.SHELL:match('fish$') then
  set.shell = '/bin/bash'
end

vim.g.rasmus_variant = 'dark'
vim.cmd([[colorscheme rasmus]])
