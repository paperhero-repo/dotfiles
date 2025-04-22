return {
	"leath-dub/snipe.nvim",
	config = function()
		require("configs.__snipe").setup()
		vim.keymap.set("n", "<leader><leader>", function()
			local api = require("snipe")
			api.open_buffer_menu()
		end, { desc = "버퍼선택기" })
	end,
}
