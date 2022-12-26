return {
	enabled = false,
	"windwp/nvim-autopairs",
	event = "VeryLazy",
	config = function()
		require("nvim-autopairs").setup()
	end,
}
