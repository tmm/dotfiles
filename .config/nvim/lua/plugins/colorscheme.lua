return {
	{
		"tmm/silo",
		name = "silo",
		dev = true,
		dir = "~/.config/nvim/silo",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme silo]])
		end,
	},
}
