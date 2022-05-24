local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  local compile_path = install_path .. '/plugin/packer_compiled.lua'
  require('packer').init({ compile_path = compile_path })
end

return require('packer').startup(function(use)
  -- Function for quick configuration
  local config = function(name)
    return string.format("require('plugins.%s')", name)
  end

  -- Plugin manager (https://github.com/wbthomason/packer.nvim)
  use({ 'wbthomason/packer.nvim' })
  -- Lua functions (https://github.com/nvim-lua/plenary.nvim)
  use({ 'nvim-lua/plenary.nvim' })
  -- Pop up API (https://github.com/nvim-lua/popup.nvim)
  use({ 'nvim-lua/popup.nvim' })
  -- Colorscheme (https://github.com/kvrohit/rasmus.nvim)
  use({ 'kvrohit/rasmus.nvim' })

  ------------------------------------------------------------------
  -- Commands
  ------------------------------------------------------------------

  -- Close buffers (https://github.com/Asheq/close-buffers.vim)
  use({ 'Asheq/close-buffers.vim' })
  -- Align whitespace (https://github.com/junegunn/vim-easy-align)
  use({ 'junegunn/vim-easy-align' })
  -- Undo history visualizer (https://github.com/mbbill/undotree)
  use({
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = function()
      vim.g.undotree_WindowLayout = 2
    end,
  })
  -- Commenting (https://github.com/numToStr/Comment.nvim)
  use({
    'numToStr/Comment.nvim',
    config = config('Comment'),
  })
  -- Window resizer (https://github.com/simeji/winresizer)
  use({ 'simeji/winresizer' })
  -- Word manipulation (https://github.com/tpope/vim-abolish)
  use({ 'tpope/vim-abolish' })
  -- Better repeat commands (https://github.com/tpope/vim-repeat)
  use({ 'tpope/vim-repeat' })
  -- Simple quoting/parenthesizing (https://github.com/tpope/vim-surround)
  use({ 'tpope/vim-surround' })
  -- Handy bracket mappings (https://github.com/tpope/vim-unimpaired)
  use({ 'tpope/vim-unimpaired' })

  ------------------------------------------------------------------
  -- Completion (https://github.com/hrsh7th/nvim-cmp)
  ------------------------------------------------------------------

  use({
    'hrsh7th/nvim-cmp',
    config = config('cmp'),
  })
  -- LSP client (https://github.com/hrsh7th/cmp-nvim-lsp)
  use({ 'hrsh7th/cmp-nvim-lsp' })
  -- Buffer words (https://github.com/hrsh7th/cmp-buffer)
  use({ 'hrsh7th/cmp-buffer' })
  -- File system paths (https://github.com/hrsh7th/cmp-path)
  use({ 'hrsh7th/cmp-path' })

  ------------------------------------------------------------------
  -- IDE
  ------------------------------------------------------------------

  -- Change directory to project root (https://github.com/airblade/vim-rooter)
  use({
    'airblade/vim-rooter',
    config = function()
      vim.g.rooter_patterns = { '.git', 'Makefile' }
    end,
  })
  -- File explorer (https://github.com/kyazdani42/nvim-tree.lua)
  use({
    'kyazdani42/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    config = config('nvim-tree'),
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  })
  -- Icons (https://github.com/kyazdani42/nvim-web-devicons)
  use({
    'kyazdani42/nvim-web-devicons',
    config = config('nvim-web-devicons'),
  })
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = config('indent_blankline'),
  })
  -- Colorizer (https://github.com/norcalli/nvim-colorizer.lua)
  use({
    'norcalli/nvim-colorizer.lua',
    config = config('colorizer'),
  })
  -- Update session automatically (https://github.com/tpope/vim-obsession)
  use({ 'tpope/vim-obsession' })
  -- Detect indent (https://github.com/tpope/vim-sleuth)
  use({ 'tpope/vim-sleuth' })
  -- Insert syntax in pairs (https://github.com/windwp/nvim-autopairs)
  use({
    'windwp/nvim-autopairs',
    config = config('nvim-autopairs'),
  })

  ------------------------------------------------------------------
  -- git
  ------------------------------------------------------------------

  -- Git decorations (https://github.com/lewis6991/gitsigns.nvim)
  use({
    'lewis6991/gitsigns.nvim',
    config = config('gitsigns'),
  })
  -- Git wrapper (https://github.com/tpope/vim-fugitive)
  use({ 'tpope/vim-fugitive' })

  ------------------------------------------------------------------
  -- LSP
  ------------------------------------------------------------------

  use({
    -- Manage LSP (https://github.com/williamboman/nvim-lsp-installer)
    'williamboman/nvim-lsp-installer',
    {
      -- Configure LSP (https://github.com/neovim/nvim-lspconfig)
      'neovim/nvim-lspconfig',
    },
  })
  -- Better sumneko_lua settings (https://github.com/folke/lua-dev.nvim)
  use({ 'folke/lua-dev.nvim' })
  -- Highlight word under cursor (https://github.com/RRethy/vim-illuminate)
  use({
    'RRethy/vim-illuminate',
  })

  ------------------------------------------------------------------
  -- Telescope (https://github.com/nvim-telescope/telescope.nvim)
  ------------------------------------------------------------------

  use({
    'nvim-telescope/telescope.nvim',
    config = config('telescope'),
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
    }
  })

  ------------------------------------------------------------------
  -- tmux
  ------------------------------------------------------------------

  -- Move between tmux panes and vim splits (https://github.com/christoomey/vim-tmux-navigator)
  use({
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_save_on_switch      = 2
    end,
  })
  -- Control tmux from vim (https://github.com/christoomey/vim-tmux-runner)
  use({
    'christoomey/vim-tmux-runner',
    config = function()
      vim.g.VtrOrientation = 'v'
      vim.g.VtrPercentage  = 20
    end,
  })

  ------------------------------------------------------------------
  -- Treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
  ------------------------------------------------------------------

  use({
    'nvim-treesitter/nvim-treesitter',
    config = config('treesitter'),
    run = ':TSUpdate',
  })
  -- Treesitter commentstring (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
  use({ 'JoosepAlviste/nvim-ts-context-commentstring' })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
