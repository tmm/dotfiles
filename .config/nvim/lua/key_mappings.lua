local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.g.mapleader = ' '

----------------------------------------------------
-- General
----------------------------------------------------

-- Move to first character on line
keymap('n', 'H', '^', opts)
-- Move to last character on line
keymap('n', 'L', 'g_', opts)

-- Move up/down five lines
keymap('n', 'J', '5j', opts)
keymap('n', 'K', '5k', opts)
keymap('v', 'J', '5j', opts)
keymap('v', 'K', '5k', opts)

-- Move up and down by visible lines if current line is wrapped
keymap('n', 'j', 'gj', opts)
keymap('n', 'k', 'gk', opts)

-- Yank to end of current line
keymap('n', 'Y', 'y$', opts)

-- Visually select text that was last edited/pasted (Vimcast#26)
keymap('n', 'gV', '`[v`]', opts)

-- Replay macro
keymap('n', 'Q', '@q', opts)

-- Remove highlights
keymap('n', '<CR>', ':noh<CR><CR>', opts)

-- Don't yank on delete character
keymap('n', 'x', '"_x', opts)
keymap('n', 'X', '"_X', opts)
keymap('v', 'x', '"_x', opts)
keymap('v', 'X', '"_X', opts)

-- Disable arrow keys
keymap('n', '<down>', '<Nop>', opts)
keymap('n', '<left>', '<Nop>', opts)
keymap('n', '<right>', '<Nop>', opts)
keymap('n', '<up>', '<Nop>', opts)

----------------------------------------------------
-- Leader
----------------------------------------------------

-- Rapid editing/sourcing config
keymap('n', '<Leader>rc', ':vsp $MYVIMRC<CR>', opts)
keymap('n', '<Leader>so', ':source $MYVIMRC<CR>', opts)

-- Quick save/quit
keymap('n', '<Leader>w', ':w<CR>', opts)
keymap('n', '<Leader>q', ':q<CR>', opts)

----------------------------------------------------
-- Plugins
----------------------------------------------------

-- Asheq/close-buffers.vim (https://github.com/Asheq/close-buffers.vim)
keymap('n', '<Leader>d', ':Bdelete menu<CR>', opts)

-- christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
keymap('n', '<Leader>va', ':VtrAttachToPane<Space>', opts)
keymap('n', '<Leader>vc', ':VtrSendCtrlC<CR>', opts)
keymap('n', '<Leader>vf', ':VtrFocusRunner!<CR>', opts)
keymap('n', '<Leader>vk', ':VtrKillRunner<CR>', opts)
keymap('n', '<Leader>vo', ':VtrOpenRunner<CR>', opts)
keymap('n', '<Leader>vv', ':VtrSendCommandToRunner<Space>', opts)

-- junegunn/vim-easy-align (https://github.com/junegunn/vim-easy-align)
keymap('n', 'ga', '<Plug>(EasyAlign)', opts)
keymap('x', 'ga', '<Plug>(EasyAlign)', opts)

-- kyazdani42/nvim-tree.lua (https://github.com/kyazdani42/nvim-tree.lua)
keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', opts)
keymap('n', '<Leader>f', ':NvimTreeFindFile<CR>', opts)

-- lewis6991/gitsigns.nvim (https://github.com/lewis6991/gitsigns.nvim)
local gitsigns = require('gitsigns')
keymap('n', '<Leader>gb', gitsigns.toggle_current_line_blame, opts)

-- mbbill/undotree (https://github.com/mbbill/undotree)
keymap('n', '<Leader>u', ':UndotreeToggle \\| UndotreeFocus<CR>', opts)

-- neovim/nvim-lspconfig (https://github.com/neovim/nvim-lspconfig)
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
keymap('n', '\\', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
keymap('n', '<space>af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- nvim-telescope/telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)
local telescopeBuiltin = require('telescope.builtin')
keymap('n', '<Leader>*', telescopeBuiltin.grep_string, opts)
keymap('n', '<Leader>b', telescopeBuiltin.buffers, opts)
keymap('n', '<Leader>p', telescopeBuiltin.find_files, opts)
keymap('n', '<Leader>rg', telescopeBuiltin.live_grep, opts)
