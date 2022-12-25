-- https://github.com/jose-elias-alvarez/null-ls.nvim
local M = {
	"jose-elias-alvarez/null-ls.nvim",
}

function M.setup(options)
	local nls = require("null-ls")
	nls.setup({
		debounce = 150,
		save_after_format = false,
		sources = {
			nls.builtins.formatting.stylua,
			nls.builtins.formatting.fish_indent,
		},
		on_attach = options.on_attach,
	})
end

function M.has_formatter(ft)
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	return #available > 0
end

return M
