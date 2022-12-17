local util = require('util')

require('mason').setup()

-- Install servers
require('mason-lspconfig').setup({
  ensure_installed = {
    'eslint',
    'sumneko_lua',
    'tsserver',
  },
  automatic_installation = true,
})
require('config.plugins.lsp.diagnostics').setup()

local function on_attach(client, bufnr)
  require('config.plugins.lsp.formatting').setup(client, bufnr)
  require('config.plugins.lsp.keys').setup(client, bufnr)
end

local servers = {
  eslint = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = {
            'after_each',
            'assert',
            'before_each',
            'describe',
            'it',
            'use',
            'vim',
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
  opts = vim.tbl_deep_extend('force', {}, options, opts or {})
  if server == 'tsserver' then
    require('typescript').setup({ server = opts })
  else
    require('lspconfig')[server].setup(opts)
  end
end