local M = {
	"echasnovski/mini.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			-- TypeScript comment plugin (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
}

function M.comment()
	require("mini.comment").setup({
		hooks = {
			pre = function()
				require("ts_context_commentstring.internal").update_commentstring({})
			end,
		},
	})
end

function M.pairs()
	require("mini.pairs").setup({})
end

function M.surround()
	require("mini.surround").setup({})
end

function M.config()
	M.comment()
	M.pairs()
end

return M
