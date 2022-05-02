----------------------------------------------------
-- Plugins
----------------------------------------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)

  use 'airblade/vim-rooter'                 -- Change directory to project root (https://github.com/airblade/vim-rooter)
  use 'christoomey/vim-tmux-navigator'      -- Move between tmux panes and vim splits (https://github.com/christoomey/vim-tmux-navigator)
  use 'christoomey/vim-tmux-runner'         -- Control tmux from vim (https://github.com/christoomey/vim-tmux-runner)
  use 'junegunn/vim-easy-align'             -- Align whitespace (https://github.com/junegunn/vim-easy-align)
  use 'Asheq/close-buffers.vim'             -- Close buffers (https://github.com/Asheq/close-buffers.vim)
  use 'lewis6991/gitsigns.nvim'             -- Git decorations (https://github.com/lewis6991/gitsigns.nvim)
  use 'lukas-reineke/indent-blankline.nvim' -- Display indents (https://github.com/nathanaelkane/vim-indent-guides)
  use 'mbbill/undotree'                     -- Undo history visualizer (https://github.com/mbbill/undotree)
  use 'norcalli/nvim-colorizer.lua'         -- Colorizer (https://github.com/norcalli/nvim-colorizer.lua)
  use 'numToStr/Comment.nvim'               -- Commenting (https://github.com/numToStr/Comment.nvim)
  use 'nvim-lua/plenary.nvim'               -- Lua functions (https://github.com/nvim-lua/plenary.nvim)
  use 'nvim-lua/popup.nvim'                 -- Pop up API (https://github.com/nvim-lua/popup.nvim)
  use 'simeji/winresizer'                   -- Window resizer (https://github.com/simeji/winresizer)
  use 'tpope/vim-abolish'                   -- Word manipulation (https://github.com/tpope/vim-abolish)
  use 'tpope/vim-fugitive'                  -- Git wrapper (https://github.com/tpope/vim-fugitive)
  use 'tpope/vim-obsession'                 -- Update session automatically (https://github.com/tpope/vim-obsession)
  use 'tpope/vim-repeat'                    -- Better repeat commands (https://github.com/tpope/vim-repeat)
  use 'tpope/vim-surround'                  -- Simple quoting/parenthesizing (https://github.com/tpope/vim-surround)
  use 'tpope/vim-unimpaired'                -- Handy bracket mappings (https://github.com/tpope/vim-unimpaired)
  use 'wbthomason/packer.nvim'              -- Plugin manager (https://github.com/wbthomason/packer.nvim)
  use 'windwp/nvim-autopairs'               -- Insert syntax in pairs (https://github.com/windwp/nvim-autopairs)

  use {
    'nvim-telescope/telescope.nvim',        -- Fuzzy finder (https://github.com/nvim-telescope/telescope.nvim)
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-lua/popup.nvim'},
    },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  
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

-- Don't yank on delete character
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

-- Asheq/close-buffers.vim (https://github.com/Asheq/close-buffers.vim)
keymap('n', '<Leader>d', ':Bdelete menu<CR>', silent)

-- christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
keymap('n', '<Leader>vv', ':VtrSendCommandToRunner<Space>', silent)
keymap('n', '<Leader>va', ':VtrAttachToPane<Space>', silent)
keymap('n', '<Leader>vc', ':VtrSendCtrlC<CR>', silent)
keymap('n', '<Leader>vf', ':VtrFocusRunner!<CR>', silent)
keymap('n', '<Leader>vk', ':VtrKillRunner<CR>', silent)
keymap('n', '<Leader>vo', ':VtrOpenRunner<CR>', silent)

-- mbbill/undotree (https://github.com/mbbill/undotree)
keymap('n', '<Leader>u', ':UndotreeToggle \\| UndotreeFocus<CR>', silent)

-- nvim-telescope/telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)
local builtin = require "telescope.builtin"
keymap('n', '<Leader>p', builtin.find_files, silent)
keymap('n', '<Leader>rg', builtin.live_grep, silent)
keymap('n', '<Leader>*', builtin.grep_string, silent)

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

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end
})

----------------------------------------------------
-- Plugin Settings
----------------------------------------------------

-- airblade/vim-rooter (https://github.com/airblade/vim-rooter)
vim.g.rooter_patterns = {'.git', 'Makefile'}

-- christoomey/vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
vim.g.tmux_navigator_disable_when_zoomed = 1
vim.g.tmux_navigator_save_on_switch      = 2

-- christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
vim.g.VtrOrientation = 'v'
vim.g.VtrPercentage  = 20

-- junegunn/vim-easy-align (https://github.com/junegunn/vim-easy-align)
keymap('n', 'ga', '<Plug>(EasyAlign)', silent)
keymap('x', 'ga', '<Plug>(EasyAlign)', silent)

-- lewis6991/gitsigns.nvim (https://github.com/lewis6991/gitsigns.nvim)
require('gitsigns').setup {
  on_attach = function(bufnr) 
    local gs = package.loaded.gitsigns 
    keymap('n', '<Leader>gb', gs.toggle_current_line_blame, silent)
  end
}

-- lukas-reineke/indent-blankline.nvim (https://github.com/nathanaelkane/vim-indent-guides)
require('indent_blankline').setup()

-- mbbill/undotree (https://github.com/mbbill/undotree)
vim.g.undotree_WindowLayout = 2
set.undodir                 = vim.env.XDG_CONFIG_HOME..'/nvim/undo'
set.undofile                = true

-- norcalli/nvim-colorizer.lua (https://github.com/norcalli/nvim-colorizer.lua)
require('colorizer').setup(
  { '*'; },
  { hsl_fn = true; names = false; }
)

-- numToStr/Comment.nvim (https://github.com/numToStr/Comment.nvim)
require('Comment').setup()

-- nvim-telescope/telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)
require('telescope').setup {}

-- windwp/nvim-autopairs (https://github.com/windwp/nvim-autopairs)
local npairs = require('nvim-autopairs')
npairs.setup()
-- npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
