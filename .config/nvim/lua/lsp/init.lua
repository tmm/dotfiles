local u = require('config.utils')

-- Install servers
require('nvim-lsp-installer').setup({
  ensure_installed = {
    'eslint',
    'sumneko_lua',
    'tsserver',
  },
  automatic_installation = true,
})

-- Add capabilities to LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- LSP options
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    u.buf_command(bufnr, 'LspFormatting', function()
      vim.lsp.buf.formatting_sync(nil, 200)
    end)

    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspFormatting',
      group = augroup,
    })
  end

  require('illuminate').on_attach(client)
end

-- Setup servers
local servers = {
  'eslint',
  'sumneko_lua',
  'tsserver',
}
for _, server in pairs(servers) do
  require('lsp.' .. server).setup(on_attach, capabilities)
end
