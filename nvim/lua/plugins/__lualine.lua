return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("configs.__lualine").setup()
	end,
}
