return {
	-- https://github.com/NvChad/nvim-colorizer.lua
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			names = false, -- "Name" codes like Blue
			mode = "background", -- Set the display mode.
			virtualtext = "■",
		},
	},

	-- https://github.com/numToStr/Navigator.nvim
	{
		"numToStr/Navigator.nvim",
		event = "VimEnter",
		opts = {
			auto_save = "current",
			disable_on_zoom = true,
		},
	},
}
