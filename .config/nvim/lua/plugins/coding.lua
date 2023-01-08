return {
	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				-- TypeScript comment plugin (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
		},
		config = function()
			require("mini.comment").setup({
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring({})
					end,
				},
			})
			require("mini.pairs").setup({})
		end,
	},

	-- https://github.com/hrsh7th/nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			-- https://github.com/hrsh7th/cmp-buffer
			"hrsh7th/cmp-buffer",
			-- https://github.com/hrsh7th/cmp-nvim-lsp
			"hrsh7th/cmp-nvim-lsp",
			-- https://github.com/hrsh7th/cmp-path
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- https://github.com/tpope/vim-repeat
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},

	-- https://github.com/tpope/vim-surround
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},

	-- https://github.com/tpope/vim-unimpaired
	{
		"tpope/vim-unimpaired",
		event = "VeryLazy",
	},
}
