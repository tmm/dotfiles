return {
	-- https://github.com/kvrohit/rasmus.nvim
	-- {
	-- 	"kvrohit/rasmus.nvim",
	-- 	event = "VimEnter",
	-- 	config = function()
	-- 		vim.g.rasmus_variant = "dark"
	-- 		vim.cmd([[colorscheme rasmus]])
	-- 	end,
	-- },

	-- https://github.com/folke/tokyonight.nvim
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
		-- event = "VimEnter",
		opts = {
			style = "night",
			sidebars = {
				"qf",
				"vista_kind",
				"terminal",
				"spectre_panel",
				"startuptime",
				"Outline",
			},
			on_highlights = function(hl, c)
				hl.CursorLineNr = { fg = c.orange, bold = true }
				hl.LineNr = { fg = c.orange, bold = true }
				hl.LineNrAbove = { fg = c.fg_gutter }
				hl.LineNrBelow = { fg = c.fg_gutter }
				local prompt = "#2d3149"
				hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
				hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
				hl.TelescopePromptNormal = { bg = prompt }
				hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
				hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
				hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
				hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }
			end,
		},
	},
}
