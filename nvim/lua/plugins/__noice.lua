return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"muniftanjim/nui.nvim",
	},
	config = function()
		require("configs.__noice").setup()
	end,
}
