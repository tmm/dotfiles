-- windwp/nvim-autopairs (https://github.com/windwp/nvim-autopairs)
local autopairs = require('nvim-autopairs')
autopairs.setup({
  check_ts = true,
  disable_filetype = { 'TelescopePrompt' },
})

local endwise = require('nvim-autopairs.ts-rule').endwise
autopairs.add_rules({
  -- 'then$' is a lua regex
  -- 'end' is a match pair
  -- 'lua' is a filetype
  -- 'if_statement' is a treesitter name. set it = nil to skip check with treesitter
  endwise('then$', 'end', 'lua', 'if_statement')
})
