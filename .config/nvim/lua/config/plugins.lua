local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  local compile_path = install_path .. '/plugin/packer_compiled.lua'
  require('packer').init({ compile_path = compile_path })
end

return require('packer').startup(function(use)
  -- Function for quick configuration
  local config = function(name)
    return string.format("require('config.plugins.%s')", name)
  end

  -- Plugin manager (https://github.com/wbthomason/packer.nvim)
  use({ 'wbthomason/packer.nvim' })
  -- Color scheme (https://github.com/kvrohit/rasmus.nvim)
  use({ 'kvrohit/rasmus.nvim' })

  use({
    -- Treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
    'nvim-treesitter/nvim-treesitter',
    config = config('treesitter'),
    run = ':TSUpdate',
    requires = {
      -- Treesitter commentstring (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
      'JoosepAlviste/nvim-ts-context-commentstring'
    }
  })

  -- Create key bindings (https://github.com/folke/which-key.nvim)
  use({ 'folke/which-key.nvim' })

  use({
    -- Incremental LSP renaming (https://github.com/smjonas/inc-rename.nvim)
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = function()
      require('inc_rename').setup()
    end,
  })
  use({
    -- Configure LSP (https://github.com/neovim/nvim-lspconfig)
    'neovim/nvim-lspconfig',
    config = config('lsp'),
    requires = {
      {
        -- Manage external editor tooling (https://github.com/williamboman/mason.nvim)
        'williamboman/mason.nvim',
        requires = {
          'williamboman/mason-lspconfig.nvim',
        }
      },
      {
        -- Hook into LSP (https://github.com/jose-elias-alvarez/null-ls.nvim)
        'jose-elias-alvarez/null-ls.nvim',
        config = config('null-ls'),
        requires = {
          -- Quick TypeScript (https://github.com/jose-elias-alvarez/typescript.nvim)
          'jose-elias-alvarez/typescript.nvim',
        }
      },
      -- Better sumneko_lua settings (https://github.com/folke/lua-dev.nvim)
      'folke/lua-dev.nvim',
    },
  })

  use({
    -- Find, Filter, Preview, Pick (https://github.com/nvim-telescope/telescope.nvim)
    'nvim-telescope/telescope.nvim',
    config = config('telescope'),
    requires = {
      -- Lua functions (https://github.com/nvim-lua/plenary.nvim)
      'nvim-lua/plenary.nvim',
      -- Pop up API (https://github.com/nvim-lua/popup.nvim)
      'nvim-lua/popup.nvim',
    }
  })

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


  use({
    'ellisonleao/glow.nvim',
    cmd = 'Glow',
    config = function()
      require('glow').setup()
    end,
  })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
