require("mason").setup()

local M = {}

M.tools = {
	"prettierd",
	"stylua",
}

function M.check()
	local mr = require("mason-registry")
	for _, tool in ipairs(M.tools) do
		local p = mr.get_package(tool)
		if not p:is_installed() then
			p:install()
		end
	end
end
M.check()

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
require("config.plugins.lsp.diagnostics").setup()

local function on_attach(client, bufnr)
	require("config.plugins.lsp.formatting").setup(client, bufnr)
	require("config.plugins.lsp.keys").setup(client, bufnr)
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

require("config.plugins.null-ls").setup(options)
