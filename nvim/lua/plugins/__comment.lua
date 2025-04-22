return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("configs.__comment").setup()
	end,
}
