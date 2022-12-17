local wk = require('which-key')

local M = {}

function M.setup(client, buffer)
  local cap = client.server_capabilities

  local keymap = {
    buffer = buffer,
    ['<leader>'] = {
      c = {
        name = '+code',
        {
          cond = client.name == 'tsserver',
          o = { '<cmd>:TypescriptOrganizeImports<cr>', 'Organize Imports' },
          R = { '<cmd>:TypescriptRenameFile<cr>', 'Rename File' },
        },
        r = {
          function()
            return ':Increname ' .. vim.fn.expand('<cword>')
          end,
          'Rename',
          cond = cap.renameProvider,
          expr = true,
        },
        a = {
          { vim.lsp.buf.code_action, 'Code Action' },
          { '<cmd>lua vim.lsp.buf.code_action()<cr>', 'Code Action', mode = 'v' },
        },
        f = {
          {
            require('config.plugins.lsp.formatting').format,
            'Format Document',
            cond = cap.documentFormatting,
          },
          {
            require('config.plugins.lsp.formatting').format,
            'Format Range',
            cond = cap.documentRangeFormatting,
            mode = 'v',
          },
        },
        d = { vim.diagnostic.open_float, 'Line Diagnostics' },
        l = {
          name = '+lsp',
          i = { '<cmd>LspInfo<cr>', 'Lsp Info' },
          a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', 'Add Folder' },
          r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', 'Remove Folder' },
          l = { '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', 'List Folders' },
        },
      },
      x = {
        d = { '<cmd>Telescope diagnostics<cr>', 'Search Diagnostics' },
      },
      v = {
        name = '+nvim',
        rc = { '<cmd>vsp $MYVIMRC<cr>', 'Edit init.lua' },
        rc = { '<cmd>source $MYVIMRC<cr>', 'Reload init.lua' },
      },
    },
    g = {
      name = '+goto',
      d = { '<cmd>Telescope lsp_definitions<cr>', 'Goto Definition' },
      r = { '<cmd>Telescope lsp_references<cr>', 'References' },
      R = { '<cmd>Trouble lsp_references<cr>', 'Trouble References' },
      D = { '<cmd>Telescope lsp_declarations<cr>', 'Goto Declaration' },
      I = { '<cmd>Telescope lsp_implementations<cr>', 'Goto Implementation' },
      t = { '<cmd>Telescope lsp_type_definitions<cr>', 'Goto Type Definition' },
    },
    ['\\'] = { '<cmd>lua vim.lsp.buf.hover()<cr>', 'Hover' },
    ['<C-k>'] = { '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'Signature Help', mode = { 'n', 'i' } },
    ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Next Diagnostic' },
    [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<cr>', 'Prev Diagnostic' },
    ['[e'] = { '<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>', 'Next Error' },
    [']e'] = { '<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>', 'Prev Error' },
    ['[w'] = {
      '<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<cr>',
      'Next Warning',
    },
    [']w'] = {
      '<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<cr>',
      'Prev Warning',
    },
  }

  wk.register(keymap)
end

return M