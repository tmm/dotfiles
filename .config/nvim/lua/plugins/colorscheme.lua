return {
	-- https://github.com/kvrohit/rasmus.nvim
	{
		"kvrohit/rasmus.nvim",
		event = "VimEnter",
		config = function()
			vim.g.rasmus_variant = "dark"
			vim.cmd([[colorscheme rasmus]])
		end,
	},
}
