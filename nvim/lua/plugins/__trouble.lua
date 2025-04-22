return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	config = function()
		require("configs.__trouble").setup()

		local map = require("core.utils").make_map("진단: ")
		map("<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", "전체")
		map("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "현제버퍼")
		map("<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", "심볼 목록")
		map("<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", "LSP 정의/목록")
		map("<leader>xL", "<cmd>Trouble loclist toggle<CR>", "위치목록")
		map("<leader>xQ", "<cmd>Trouble qflist toggle<CR>", "빠른수정  목록")
	end,
}
