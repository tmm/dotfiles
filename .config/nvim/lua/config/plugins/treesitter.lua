require('nvim-treesitter.configs').setup({
  autopairs = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  ensure_installed = {
    'bash',
    'fish',
    'javascript',
    'json',
    'lua',
    'markdown',
    'tsx',
    'typescript',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
