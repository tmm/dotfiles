local api = vim.api

local M = {}

M.buf_command = function(bufnr, name, fn, opts)
  api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

return M
