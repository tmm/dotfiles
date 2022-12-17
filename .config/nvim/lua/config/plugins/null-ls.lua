-- jose-elias-alvarez/null-ls.nvim (https://github.com/jose-elias-alvarez/null-ls.nvim)
require('null-ls').setup({
  debounce = 150,
  save_after_format = false,
})

local M = {}

function M.has_formatter(ft)
  local sources = require('null-ls.sources')
  local available = sources.get_available(ft, 'NULL_LS_FORMATTING')
  return #available > 0
end

return M