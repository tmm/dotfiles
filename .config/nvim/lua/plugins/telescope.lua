-- https://github.com/nvim-telescope/telescope.nvim
local M = {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },
	dependencies = {
		-- Lua functions (https://github.com/nvim-lua/plenary.nvim)
		"nvim-lua/plenary.nvim",
		-- Pop up API (https://github.com/nvim-lua/popup.nvim)
		"nvim-lua/popup.nvim",
	},
}

function M.config()
	local actions = require("telescope.actions")

	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
			},
			prompt_prefix = "❯ ",
			selection_caret = "→ ",
		},
		pickers = {
			buffers = {
				ignore_current_buffer = true,
				sort_lastused = true,
				theme = "dropdown",
			},
			find_files = {
				theme = "dropdown",
			},
			grep_string = {
				theme = "dropdown",
			},
			live_grep = {
				theme = "dropdown",
			},
		},
	})
end

return M
