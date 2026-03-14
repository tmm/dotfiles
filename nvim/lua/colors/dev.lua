local ns = vim.api.nvim_create_namespace("tmm_color_preview")
local group = vim.api.nvim_create_augroup("tmm_dev", { clear = true })

local M = {}

function M.preview()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local start, finish, name = line:find('hi%("([^"]+)"')
    if name and start then
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
      if ok then
        local col_start = start + 2
        local col_end = finish
        local preview_name
        if next(hl) ~= nil then
          local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
          preview_name = "TmmPreview_" .. name
          vim.api.nvim_set_hl(0, preview_name, vim.tbl_extend("keep", hl, { fg = normal.fg }))
        else
          preview_name = "Normal"
        end
        vim.api.nvim_buf_set_extmark(buf, ns, i - 1, col_start, {
          end_col = col_end,
          hl_group = preview_name,
        })
      end
    end
  end
end

function M.clear()
  vim.api.nvim_buf_clear_namespace(vim.api.nvim_get_current_buf(), ns, 0, -1)
end

vim.api.nvim_create_user_command("ColorPreview", M.preview, {})
vim.api.nvim_create_user_command("ColorPreviewClear", M.clear, {})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  pattern = "*/colors/highlights.lua",
  callback = function()
    vim.defer_fn(M.preview, 100)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "tmm",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("colors/highlights%.lua$") and vim.api.nvim_buf_is_loaded(buf) then
        vim.defer_fn(function()
          vim.api.nvim_buf_call(buf, M.preview)
        end, 50)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = group,
  pattern = { "*/colors/highlights.lua", "*/colors/palette.lua" },
  callback = function()
    vim.cmd.colorscheme("tmm")
    vim.defer_fn(M.preview, 50)
  end,
})

return M
