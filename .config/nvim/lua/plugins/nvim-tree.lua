-- kyazdani42/nvim-tree.lua (https://github.com/kyazdani42/nvim-tree.lua)
require('nvim-tree').setup({
  filters = {
    dotfiles = false,
    exclude = {
      'dist',
      'node_modules',
    },
  },
})
