-- JoosepAlviste/nvim-ts-context-commentstring (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
require('nvim-treesitter.configs').setup({
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  ensure_installed = {
    'tsx',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
