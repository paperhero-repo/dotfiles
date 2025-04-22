return {
	"shellRaining/hlchunk.nvim",
	event = "VeryLazy",
	config = function()
		require("configs.__hlchunk").setup()
	end,
}
