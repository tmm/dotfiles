return {
	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		name = "lsp",
		event = "BufReadPre",
		dependencies = {
			-- https://github.com/williamboman/mason.nvim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- https://github.com/jose-elias-alvarez/null-ls.nvim
			"jose-elias-alvarez/null-ls.nvim",
			-- https://github.com/jose-elias-alvarez/typescript.nvim
			"jose-elias-alvarez/typescript.nvim",
			-- https://github.com/folke/lua-dev.nvim
			"folke/lua-dev.nvim",
			-- https://github.com/smjonas/inc-rename.nvim
			"smjonas/inc-rename.nvim",
		},
		config = function()
			require("mason").setup()

			local tools = {
				"prettierd",
				"stylua",
			}
			local mr = require("mason-registry")
			for _, tool in ipairs(tools) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = {
					"eslint",
					"marksman",
					"sumneko_lua",
					"tsserver",
				},
				automatic_installation = true,
			})

			local servers = {
				eslint = {},
				marksman = {},
				sumneko_lua = {
					settings = {
						Lua = {
							diagnostics = {
								globals = {
									"after_each",
									"assert",
									"before_each",
									"describe",
									"it",
									"require",
									"use",
									"vim",
								},
							},
							format = {
								enable = true,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
				tsserver = {},
			}

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			})

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function on_attach(client, bufnr)
				require("plugins.lsp.format").on_attach(client, bufnr)
				require("plugins.lsp.keymaps").on_attach(client, bufnr)
			end

			local options = {
				on_attach = on_attach,
				capabilities = capabilities,
				flags = {
					debounce_text_changes = 150,
				},
			}

			for server, opts in pairs(servers) do
				opts = vim.tbl_deep_extend("force", {}, options, opts or {})
				if server == "tsserver" then
					require("typescript").setup({ server = opts })
				else
					require("lspconfig")[server].setup(opts)
				end
			end

			local nls = require("null-ls")
			nls.setup({
				debounce = 150,
				save_after_format = false,
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.fish_indent,
				},
				on_attach = on_attach,
			})
		end,
	},
}
