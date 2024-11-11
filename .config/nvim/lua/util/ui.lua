---@class util.ui
local M = {}

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- no highlight, no foldexpr
  if not vim.b[buf].ts_highlight then
    return "0"
  end

  -- still in the same tick and no parser
  if M.skip_foldexpr[buf] then
    return "0"
  end

  -- don't use treesitter folds for terminal
  if vim.bo[buf].buftype == "terminal" then
    return "0"
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == "" then
    return "0"
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end

  -- no parser available, so mark it as skip
  -- in the next tick, all skip marks will be reset
  M.skip_foldexpr[buf] = true
  skip_check:start(function()
    M.skip_foldexpr = {}
    skip_check:stop()
    M.skip_foldexpr = {}
    skip_check:stop()
  end)
  return "0"
end

function M.parse_line(linenr)
  local bufnr = vim.api.nvim_get_current_buf()

  local line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]
  if not line then
    return nil
  end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok then
    return nil
  end

  local query = vim.treesitter.query.get(parser:lang(), "highlights")
  if not query then
    return nil
  end

  local tree = parser:parse({ linenr - 1, linenr })[1]

  local result = {}

  local line_pos = 0

  for id, node, metadata in query:iter_captures(tree:root(), 0, linenr - 1, linenr) do
    local name = query.captures[id]
    local start_row, start_col, end_row, end_col = node:range()

    local priority = tonumber(metadata.priority or vim.highlight.priorities.treesitter)

    if start_row == linenr - 1 and end_row == linenr - 1 then
      -- check for characters ignored by treesitter
      if start_col > line_pos then
        table.insert(result, {
          line:sub(line_pos + 1, start_col),
          { { "Folded", priority } },
          range = { line_pos, start_col },
        })
      end
      line_pos = end_col

      local text = line:sub(start_col + 1, end_col)
      table.insert(result, { text, { { "@" .. name, priority } }, range = { start_col, end_col } })
    end
  end

  local i = 1
  while i <= #result do
    -- find first capture that is not in current range and apply highlights on the way
    local j = i + 1
    while j <= #result and result[j].range[1] >= result[i].range[1] and result[j].range[2] <= result[i].range[2] do
      for k, v in ipairs(result[i][2]) do
        if not vim.tbl_contains(result[j][2], v) then
          table.insert(result[j][2], k, v)
        end
      end
      j = j + 1
    end

    -- remove the parent capture if it is split into children
    if j > i + 1 then
      table.remove(result, i)
    else
      -- highlights need to be sorted by priority, on equal prio, the deeper nested capture (earlier
      -- in list) should be considered higher prio
      if #result[i][2] > 1 then
        table.sort(result[i][2], function(a, b)
          return a[2] < b[2]
        end)
      end

      result[i][2] = vim.tbl_map(function(tbl)
        return tbl[1]
      end, result[i][2])
      result[i] = { result[i][1], result[i][2] }

      i = i + 1
    end
  end

  return result
end

-- Based on https://github.com/Wansmer/nvim-config/blob/main/lua/modules/foldtext.lua
-- Which is based on https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/
function M.foldtext()
  local result = M.parse_line(vim.v.foldstart)
  if not result then
    return vim.fn.foldtext()
  end

  local line_count = vim.v.foldend - vim.v.foldstart - 1
  local folded = {
    { " +" .. line_count .. " " .. (line_count == 1 and "line" or "lines") .. " ", "FoldedText" },
  }

  for _, item in ipairs(folded) do
    table.insert(result, item)
  end

  local result2 = M.parse_line(vim.v.foldend)
  if result2 then
    local first = result2[1]
    result2[1] = { vim.trim(first[1]), first[2] }
    for _, item in ipairs(result2) do
      table.insert(result, item)
    end
  end

  return result
end

function M.maximize()
  ---@type {k:string, v:any}[]?
  local maximized = nil
  return require("snacks").toggle({
    name = "Maximize",
    get = function()
      return maximized ~= nil
    end,
    set = function(state)
      if state then
        maximized = {}
        local function set(k, v)
          table.insert(maximized, 1, { k = k, v = vim.o[k] })
          vim.o[k] = v
        end
        set("winwidth", 999)
        set("winheight", 999)
        set("winminwidth", 10)
        set("winminheight", 4)
        vim.cmd("wincmd =")
        -- `QuitPre` seems to be executed even if we quit a normal window, so we don't want that
        -- `VimLeavePre` might be another consideration? Not sure about differences between the 2
        vim.api.nvim_create_autocmd("ExitPre", {
          once = true,
          group = vim.api.nvim_create_augroup("lazyvim_restore_max_exit_pre", { clear = true }),
          desc = "Restore width/height when close Neovim while maximized",
          callback = function()
            M.maximize.set(false)
          end,
        })
      else
        for _, opt in ipairs(maximized) do
          vim.o[opt.k] = opt.v
        end
        maximized = nil
        vim.cmd("wincmd =")
      end
    end,
  })
end

return M
