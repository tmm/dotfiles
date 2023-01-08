return {
	-- https://github.com/nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		config = function()
			require("nvim-treesitter.configs").setup({
				autopairs = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				ensure_installed = {
					"bash",
					"fish",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"tsx",
					"typescript",
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = false,
				},
			})
		end,
	},
}
