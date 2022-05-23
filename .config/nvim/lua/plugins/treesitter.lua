require('nvim-treesitter.configs').setup({
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
  ensure_installed = {
    'fish',
    'tsx',
    'typescript',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
