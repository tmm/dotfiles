local util = require("util")

util.require("config.options")
util.require("config.lazy")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		util.version()
		util.require("config.commands")
		util.require("config.keymaps")
	end,
})
