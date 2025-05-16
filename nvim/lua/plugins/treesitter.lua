return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- 텍스트 객체 확장
		"nvim-treesitter/playground",                -- 구문 트리 시각화 (선택)
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { -- 설치할 언어 파서 목록 업데이트
				"lua",
				"python",
				"javascript",
				"typescript",
				"html",
				"css",
				"json",
				"bash",
				"vim",
				"go",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true, -- 오타 수정: enbale → enable
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@comment.outer", -- 주석 블록 선택
						["ic"] = "@comment.inner", -- 내부 주석 선택
						["am"] = "@function.method", -- 메서드 선택
					},
				},
			},
		})
	end,
}
