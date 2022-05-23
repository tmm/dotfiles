local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require('lspconfig')

  lspconfig.tsserver.setup({
    capabilities = capabilities,
    settings = {
      format = {
        enable = false,
      },
    },
    on_attach = function(client, bufnr)
      -- Use eslint for formatting instead
      client.resolved_capabilities.document_formatting = false
      on_attach(client, bufnr)
    end,

  })
end

return M
