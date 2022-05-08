local servers = {
  'sumneko_lua',
  'tsserver',
}

------------------------------------------------------------------
-- williamboman/nvim-lsp-installer (https://github.com/williamboman/nvim-lsp-installer)
------------------------------------------------------------------

require('nvim-lsp-installer').setup({
  ensure_installed = servers,
  automatic_installation = true,
})

------------------------------------------------------------------
-- neovim/nvim-lspconfig (https://github.com/neovim/nvim-lspconfig)
------------------------------------------------------------------

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lspconfig = require('lspconfig')
for _, server in pairs(servers) do
  lspconfig[server].setup({})
end

lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})
