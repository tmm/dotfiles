-- https://github.com/kvrohit/rasmus.nvim
return {
	"kvrohit/rasmus.nvim",
	event = "VimEnter",
	config = function()
		vim.g.rasmus_variant = "dark"
		vim.cmd([[colorscheme rasmus]])
	end,
}
