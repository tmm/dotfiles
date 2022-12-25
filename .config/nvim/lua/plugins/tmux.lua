return {
	-- Navigate between vim and tmux splits (https://github.com/christoomey/vim-tmux-navigator)
	"christoomey/vim-tmux-navigator",
	event = "VeryLazy",
	dependencies = {
		-- Run tmux commands from vim (https://github.com/christoomey/vim-tmux-runner)
		"christoomey/vim-tmux-runner",
	},
	config = function()
		vim.g.tmux_navigator_disable_when_zoomed = 1
		vim.g.tmux_navigator_save_on_switch = 2
		vim.g.VtrOrientation = "v"
		vim.g.VtrPercentage = 20
	end,
}
