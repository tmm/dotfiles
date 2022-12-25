-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
	"nvim-neo-tree/neo-tree.nvim",
	cmd = "Neotree",
	dependencies = {
		-- Lua functions (https://github.com/nvim-lua/plenary.nvim)
		"nvim-lua/plenary.nvim",
		-- Dev icons (https://github.com/nvim-tree/nvim-web-devicons)
		"nvim-tree/nvim-web-devicons",
		-- UI Component library (https://github.com/MunifTanjim/nui.nvim)
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

		require("neo-tree").setup({
			filesystem = {
				follow_current_file = true,
				hijack_netrw_behavior = "open_current",
			},
		})
		require("nvim-web-devicons").setup({ default = true })
	end,
}
