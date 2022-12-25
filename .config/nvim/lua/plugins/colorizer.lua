-- https://github.com/NvChad/nvim-colorizer.lua
return {
	"NvChad/nvim-colorizer.lua",
	event = "BufReadPre",
	config = function()
		require("colorizer").setup({
			names = false, -- "Name" codes like Blue
			mode = "background", -- Set the display mode.
			virtualtext = "■",
		})
	end,
}
