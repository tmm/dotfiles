return {
	-- https://github.com/lukas-reineke/indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		opts = {
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
		},
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
					always_divide_middle = true,
					component_separators = "",
					disabled_filetypes = {
						"neo-tree",
					},
					globalstatus = false,
					icons_enabled = true,
					section_separators = "",
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

	-- https://github.com/petertriho/nvim-scrollbar
	-- {
	-- 	"petertriho/nvim-scrollbar",
	-- 	event = "BufReadPost",
	-- 	config = function()
	-- 		local scrollbar = require("scrollbar")
	-- 		-- local colors = require("tokyonight.colors").setup()
	-- 		local colors = require("vscode.colors").get_colors()
	-- 		scrollbar.setup({
	-- 			handle = {
	-- 				color = colors.vscPopupBack,
	-- 			},
	-- 			excluded_filetypes = { "prompt", "TelescopePrompt", "noice", "notify", "neo-tree" },
	-- 			marks = {
	-- 				Search = { color = colors.vscOrange },
	-- 				Error = { color = colors.vscRed },
	-- 				Warn = { color = colors.vscYellow },
	-- 				Info = { color = colors.vscGreen },
	-- 				Hint = { color = colors.vscBlue },
	-- 				Misc = { color = colors.vscViolet },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- https://github.com/stevearc/dressing.nvim
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			vim.ui.select = function(...)
				require("dressing").setup()
				return vim.ui.select(...)
			end
			vim.ui.input = function(...)
				require("dressing").setup()
				return vim.ui.input(...)
			end
		end,
	},
}
