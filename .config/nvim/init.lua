----------------------------------------------------
-- Plugins
----------------------------------------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  use 'norcalli/nvim-colorizer.lua' -- Colorizer (https://github.com/norcalli/nvim-colorizer.lua)
  use 'tpope/vim-abolish'           -- Word manipulation (https://github.com/tpope/vim-abolish)
  use 'tpope/vim-obsession'         -- Update session automatically (https://github.com/tpope/vim-obsession)
  use 'tpope/vim-repeat'            -- Better repeat commands (https://github.com/tpope/vim-repeat)
  use 'tpope/vim-surround'          -- Simple quoting/parenthesizing (https://github.com/tpope/vim-surround)
  use 'tpope/vim-unimpaired'        -- Handy bracket mappings (https://github.com/tpope/vim-unimpaired)
  use 'wbthomason/packer.nvim'      -- Plugin manager (https://github.com/wbthomason/packer.nvim)

  if packer_bootstrap then
    require('packer').sync()
  end
end)

----------------------------------------------------
-- General
----------------------------------------------------
local set = vim.opt

set.clipboard      = 'unnamed,unnamedplus' -- Use clipboard for all operations
set.cursorline     = true                  -- Highlight current line
set.expandtab      = true                  -- Expand tabs into spaces
set.foldmethod     = 'syntax'
set.foldlevelstart = 1                     -- Some folds closed
set.hidden         = true                  -- Handle multiple buffers better
set.number         = true                  -- Show line numbers
set.relativenumber = true                  -- Line numbers relative to cursor
set.scrolloff      = 4                     -- Always show at least four lines above/below cursor
set.shortmess      = 'Iac'                 -- Disable start up message and abbreviate items
set.showbreak      = '↪'
set.sidescrolloff  = 4                     -- Always show at least four columns left/right cursor
set.signcolumn     = 'yes'                 -- Always show the signcolumn
set.smartcase      = true                  -- Switch to case-sensitive search for capital letters
set.splitbelow     = true                  -- More natural split opening
set.splitright     = true
set.termguicolors  = true                  -- Support for true color (https://github.com/termstandard/colors)
set.title          = true                  -- Set terminal title
set.updatetime     = 100                   -- Faster update time
set.visualbell     = true                  -- Disable beeping
set.wildmode       = 'longest:full,full'   -- Completion settings

----------------------------------------------------
-- Key Mappings
----------------------------------------------------
local keymap = vim.keymap.set
local silent = { silent = true }

-- Move to first character on line
keymap('n', 'H', '^', silent)
-- Move to last character on line
keymap('n', 'L', 'g_', silent)

-- Move up/down five lines
keymap('n', 'J', '5j', silent)
keymap('n', 'K', '5k', silent)
keymap('v', 'J', '5j', silent)
keymap('v', 'K', '5k', silent)

-- Move up and down by visible lines if current line is wrapped
keymap('n', 'j', 'gj', silent)
keymap('n', 'k', 'gk', silent)

-- Yank to end of current line
keymap('n', 'Y', 'y$', silent)

-- Visually select text that was last edited/pasted (Vimcast#26)
keymap('n', 'gV', '`[v`]', silent)

-- Replay macro
keymap('n', 'Q', '@q', silent)

-- Remove highlights
keymap('n', '<CR>', ':noh<CR><CR>', silent)

-- Don't yank on delete char
keymap('n', 'x', '"_x', silent)
keymap('n', 'X', '"_X', silent)
keymap('v', 'x', '"_x', silent)
keymap('v', 'X', '"_X', silent)

-- Disable arrow keys
keymap('n', '<down>', '<Nop>', silent)
keymap('n', '<left>', '<Nop>', silent)
keymap('n', '<right>', '<Nop>', silent)
keymap('n', '<up>', '<Nop>', silent)

----------------------------------------------------
-- Leader Commands
----------------------------------------------------
vim.g.mapleader = ' '

-- Rapid editing/sourcing config
keymap('n', '<Leader>rc', ':vsp $MYVIMRC<CR>', silent)
keymap('n', '<Leader>so', ':source $MYVIMRC<CR>', silent)

-- Quick save/quit
keymap('n', '<Leader>w', ':w<CR>', silent)
keymap('n', '<Leader>q', ':q<CR>', silent)

----------------------------------------------------
-- Autocommands
----------------------------------------------------
local au = vim.api.nvim_create_autocmd

-- Hybrid line numbers
-- Switch between relative and absolute line numbers based on mode
local number_toggle = vim.api.nvim_create_augroup('number_toggle', { clear = true })

au({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  callback = function()
    if vim.opt.number:get() == true then
      vim.opt.relativenumber = true
    end
  end,
  group = number_toggle,
})

au({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  callback = function()
    if vim.opt.number:get() == true then
      vim.opt.relativenumber = false
    end
  end,
  group = number_toggle,
})

----------------------------------------------------
-- Plugin Settings
----------------------------------------------------

-- norcalli/nvim-colorizer.lua (https://github.com/norcalli/nvim-colorizer.lua)
require('colorizer').setup(
  { '*'; },
  { hsl_fn = true; names = false; }
)
