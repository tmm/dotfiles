-- windwp/nvim-autopairs (https://github.com/windwp/nvim-autopairs)
local autopairs = require('nvim-autopairs')
autopairs.setup({
  check_ts = true,
  disable_filetype = { 'TelescopePrompt' },
})
autopairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
