---@class util.ui
local M = {}

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
function M.get_signs(buf, lnum)
	-- Get regular signs
	---@type Sign[]
	local signs = {}

	if vim.fn.has("nvim-0.10") == 0 then
		-- Only needed for Neovim <0.10
		-- Newer versions include legacy signs in nvim_buf_get_extmarks
		for _, sign in ipairs(vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs) do
			local ret = vim.fn.sign_getdefined(sign.name)[1] --[[@as Sign]]
			if ret then
				ret.priority = sign.priority
				signs[#signs + 1] = ret
			end
		end
	end

	-- Get extmark signs
	local extmarks = vim.api.nvim_buf_get_extmarks(
		buf,
		-1,
		{ lnum - 1, 0 },
		{ lnum - 1, -1 },
		{ details = true, type = "sign" }
	)
	for _, extmark in pairs(extmarks) do
		signs[#signs + 1] = {
			name = extmark[4].sign_hl_group or extmark[4].sign_name or "",
			text = extmark[4].sign_text,
			texthl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		}
	end

	-- Sort by priority
	table.sort(signs, function(a, b)
		return (a.priority or 0) < (b.priority or 0)
	end)

	return signs
end

---@return Sign?
---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
	local marks = vim.fn.getmarklist(buf)
	vim.list_extend(marks, vim.fn.getmarklist())
	for _, mark in ipairs(marks) do
		if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
			return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
		end
	end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
	sign = sign or {}
	len = len or 2
	local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
	text = text .. string.rep(" ", len - vim.fn.strchars(text))
	return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

function M.statuscolumn()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local is_file = vim.bo[buf].buftype == ""
	local show_signs = vim.wo[win].signcolumn ~= "no"

	local components = { "", "", "" } -- left, middle, right

	local show_open_folds = vim.g.tmm_statuscolumn and vim.g.tmm_statuscolumn.folds_open
	local use_githl = vim.g.tmm_statuscolumn and vim.g.tmm_statuscolumn.folds_githl

	if show_signs then
		local signs = M.get_signs(buf, vim.v.lnum)

		---@type Sign?,Sign?,Sign?
		local left, right, fold, githl
		for _, s in ipairs(signs) do
			if s.name and (s.name:find("GitSign") or s.name:find("MiniDiffSign")) then
				right = s
				if use_githl then
					githl = s["texthl"]
				end
			else
				left = s
			end
		end

		vim.api.nvim_win_call(win, function()
			if vim.fn.foldclosed(vim.v.lnum) >= 0 then
				fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = githl or "Folded" }
			elseif
				show_open_folds
				and not M.skip_foldexpr[buf]
				and tostring(vim.treesitter.foldexpr(vim.v.lnum)):sub(1, 1) == ">"
			then -- fold start
				fold = { text = vim.opt.fillchars:get().foldopen or "", texthl = githl }
			end
		end)
		-- Left: mark or non-git sign
		components[1] = M.icon(M.get_mark(buf, vim.v.lnum) or left)
		-- Right: fold icon or git sign (only if file)
		components[3] = is_file and M.icon(fold or right) or ""
	end

	-- Numbers in Neovim are weird
	-- They show when either number or relativenumber is true
	local is_num = vim.wo[win].number
	local is_relnum = vim.wo[win].relativenumber
	if (is_num or is_relnum) and vim.v.virtnum == 0 then
		if vim.fn.has("nvim-0.11") == 1 then
			components[2] = "%l" -- 0.11 handles both the current and other lines with %l
		else
			if vim.v.relnum == 0 then
				components[2] = is_num and "%l" or "%r" -- the current line
			else
				components[2] = is_relnum and "%r" or "%l" -- other lines
			end
		end
		components[2] = "%=" .. components[2] .. " " -- right align
	end

	if vim.v.virtnum ~= 0 then
		components[2] = "%= "
	end

	return table.concat(components, "")
end

M.skip_foldexpr = {} ---@type table<number,boolean>
local skip_check = assert(vim.uv.new_check())

function M.foldexpr()
	local buf = vim.api.nvim_get_current_buf()

	-- still in the same tick and no parser
	if M.skip_foldexpr[buf] then
		return "0"
	end

	-- don't use treesitter folds for non-file buffers
	if vim.bo[buf].buftype ~= "" then
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

function M.bufremove(buf)
	buf = buf or 0
	buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

	if vim.bo.modified then
		local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
		if choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
			return
		end
		if choice == 1 then -- Yes
			vim.cmd.write()
		end
	end

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
				return
			end
			-- Try using alternate buffer
			local alt = vim.fn.bufnr("#")
			if alt ~= buf and vim.fn.buflisted(alt) == 1 then
				vim.api.nvim_win_set_buf(win, alt)
				return
			end

			-- Try using previous buffer
			local has_previous = pcall(vim.cmd, "bprevious")
			if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
				return
			end

			-- Create new listed buffer
			local new_buf = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(win, new_buf)
		end)
	end
	if vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.cmd, "bdelete! " .. buf)
	end
end

return M
