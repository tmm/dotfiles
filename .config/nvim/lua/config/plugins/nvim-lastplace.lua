-- ethanholz/nvim-lastplace (https://github.com/ethanholz/nvim-lastplace)
require('nvim-lastplace').setup({
  lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help', 'Telescope' },
  lastplace_ignore_filetype = { 'gitcommit', 'gitrebase' },
  lastplace_open_folds = true,
})
