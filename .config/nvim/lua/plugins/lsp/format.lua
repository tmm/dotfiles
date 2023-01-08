local M = {}

M.autoformat = true

function M.toggle()
	M.autoformat = not M.autoformat
	vim.notify(M.autoformat and "Enabled format on save" or "Disabled format on save")
end

function M.format()
	if vim.lsp.buf.format then
		vim.lsp.buf.format()
	else
		vim.lsp.buf.formatting_sync()
	end
end

function M.on_attach(client, buf)
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	local has_formatter = #available > 0

	local enable = false
	if has_formatter then
		enable = client.name == "null-ls"
	else
		enable = not (client.name == "null-ls")
	end

	if client.name == "tsserver" then
		enable = false
	end

	client.server_capabilities.documentFormattingProvider = enable
	if enable then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
			buffer = buf,
			callback = function()
				if M.autoformat then
					M.format()
				end
			end,
		})
	end
end

return M
