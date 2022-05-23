local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require('lspconfig')

  local luadev = require('lua-dev').setup({
    lspconfig = {
      capabilities = capabilities,
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
      on_attach = on_attach,
    },
  })

  lspconfig.sumneko_lua.setup(luadev)
end

return M
