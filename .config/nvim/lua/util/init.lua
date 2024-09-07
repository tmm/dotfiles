local LazyUtil = require("lazy.core.util")

local M = {}

function M.is_win()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param name string
function M.get_plugin(name)
	return require("lazy.core.config").spec.plugins[name]
end

---@param name string
function M.opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
	if vim.api.nvim_get_mode().mode == "i" then
		vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
	end
end

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
	M[level] = function(msg, opts)
		opts = opts or {}
		opts.title = opts.title or "LazyVim"
		return LazyUtil[level](msg, opts)
	end
end

---@param path string
function M.norm(path)
	path = vim.fs.normalize(path)
	-- Special case for Windows drive letters
	-- vim.fs.normalize doesn't handle them correctly
	if path:sub(2, 2) == ":" then
		path = path:sub(1, 1):lower() .. path:sub(2)
	end
	return path
end

local function can_merge(v)
	return type(v) == "table" and (vim.tbl_isempty(v) or not M.is_list(v))
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function M.merge(...)
	local ret = select(1, ...)
	if ret == vim.NIL then
		ret = nil
	end
	for i = 2, select("#", ...) do
		local value = select(i, ...)
		if can_merge(ret) and can_merge(value) then
			for k, v in pairs(value) do
				ret[k] = M.merge(ret[k], v)
			end
		elseif value == vim.NIL then
			ret = nil
		elseif value ~= nil then
			ret = value
		end
	end
	return ret
end

return M
