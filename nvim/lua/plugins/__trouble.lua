return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>tt", ":Trouble todo filter = { tag = {TODO} }<CR>", desc = "TODOs 표시" },
		{ "<leader>tf", ":Trouble todo filter = { tag = {FIX,FIXME} }<CR>", desc = "수정필요 표시" },
		{ "<leader>tn", ":Trouble todo filter = { tag = {NOTE} }<CR>", desc = "참고 표시" },
		{ "<leader>tr", "<cmd>TroubleToggle<cr>", desc = "Trouble 표시/숨김" },
		{ "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "워크스페이스 진단" },
		{ "<leader>td", "<cmd>Trouble document_diagnostics<cr>", desc = "문서 진단" },
		{ "<leader>tll", "<cmd>Trouble loclist<cr>", desc = "위치 목록" },
		{ "<leader>tq", "<cmd>Trouble quickfix<cr>", desc = "빠른 수정 목록" },
		{ "<leader>tl", "<cmd>Trouble lsp_references<cr>", desc = "LSP 참조" },
	},
	cmd = "Trouble",
	config = function()
		require("configs.__trouble").setup()
	end,
}
