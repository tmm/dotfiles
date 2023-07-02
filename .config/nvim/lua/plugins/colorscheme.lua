return {
	-- https://github.com/catppuccin/nvim
	{
		"catppuccin/nvim",
		name = "catppuccin",
		event = "BufReadPre",
		background = {
			light = "latte",
			dark = "mocha",
		},
		integrations = {
			cmp = true,
			gitsigns = true,
			illuminate = false,
			lsp_trouble = false,
			nvimtree = true,
			telescope = true,
			which_key = false,
		},
		priority = 1000,
	},
}
