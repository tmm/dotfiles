-- https://github.com/neovim/nvim-lspconfig
local M = {
	"neovim/nvim-lspconfig",
	name = "lsp",
	event = "BufReadPre",
	dependencies = {
		-- Manage external editor tooling (https://github.com/williamboman/mason.nvim)
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- Hook into LSP (https://github.com/jose-elias-alvarez/null-ls.nvim)
		"jose-elias-alvarez/null-ls.nvim",
		-- Quick TypeScript (https://github.com/jose-elias-alvarez/typescript.nvim)
		"jose-elias-alvarez/typescript.nvim",
		-- Better sumneko_lua settings (https://github.com/folke/lua-dev.nvim)
		"folke/lua-dev.nvim",
		-- Incremental LSP renaming (https://github.com/smjonas/inc-rename.nvim)
		"smjonas/inc-rename.nvim",
	},
}

function M.config()
	require("mason").setup()

	local P = {}
	P.tools = {
		"prettierd",
		"stylua",
	}

	function P.check()
		local mr = require("mason-registry")
		for _, tool in ipairs(P.tools) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end
	P.check()

	-- Install servers
	require("mason-lspconfig").setup({
		ensure_installed = {
			"eslint",
			"marksman",
			"sumneko_lua",
			"tsserver",
		},
		automatic_installation = true,
	})
	require("plugins.lsp.diagnostics").setup()

	local function on_attach(client, bufnr)
		require("plugins.lsp.formatting").setup(client, bufnr)
		require("plugins.lsp.keys").setup(client, bufnr)
	end

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

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

	require("plugins.null-ls").setup(options)
end

return M
