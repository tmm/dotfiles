-- windwp/nvim-autopairs (https://github.com/windwp/nvim-autopairs)
local autopairs = require('nvim-autopairs')
autopairs.setup({
  disable_filetype = { 'TelescopePrompt' },
})
autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
