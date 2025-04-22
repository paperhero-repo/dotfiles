return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- { "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
		"ray-x/lsp_signature.nvim",
		"mfussenegger/nvim-lint",
	},
	config = function()
		require("configs.__lspconfig").setup() -- 설정 파일 연결
	end,
}
