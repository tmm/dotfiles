-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
	config = function()
		local indent = require("indent_blankline")
		indent.setup({
			buftype_exclude = { "nofile" },
			char = "│",
			filetype_exclude = {
				"help",
				"startify",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
			},
			use_treesitter_scope = false,
			show_trailing_blankline_indent = false,
			show_current_context = true,
		})
	end,
}
