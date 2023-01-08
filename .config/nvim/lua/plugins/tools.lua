return {
	-- https://github.com/NvChad/nvim-colorizer.lua
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				names = false, -- "Name" codes like Blue
				mode = "background", -- Set the display mode.
				virtualtext = "■",
			})
		end,
	},

	-- https://github.com/christoomey/vim-tmux-navigator
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		dependencies = {
			-- https://github.com/christoomey/vim-tmux-runner
			"christoomey/vim-tmux-runner",
		},
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
			vim.g.tmux_navigator_save_on_switch = 2
			vim.g.VtrOrientation = "v"
			vim.g.VtrPercentage = 20
		end,
	},
}
