return {
	-- https://github.com/lukas-reineke/indent-blankline.nvim
	{
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
	},

	-- https://github.com/nvim-lualine/lualine.nvim
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = "",
					section_separators = "",
					disabled_filetypes = {
						"NvimTree",
					},
					always_divide_middle = true,
					globalstatus = false,
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						"mode",
						{
							"filename",
							cond = conditions.buffer_not_empty,
						},
						{
							"branch",
							icon = "",
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " " },
						},
						"filetype",
						"progress",
						"location",
					},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},
}
