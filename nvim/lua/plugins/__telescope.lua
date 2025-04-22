return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("configs.__telescope").setup()

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = require("core.utils").make_map("Tele:", event.buf)
				-- LSP 기본 기능
				map("gd", vim.lsp.buf.definition, "정의로 이동")
				map("gr", vim.lsp.buf.references, "참조 검색")

				map("<leader>rn", vim.lsp.buf.rename, "심볼 이름 변경")
				map("<leader>ca", vim.lsp.buf.code_action, "코드 작업 실행", { "n", "v" }) -- ※ 모드 수정
				map("gD", vim.lsp.buf.declaration, "선언부 이동")

				-- Telescope 기능
				local builtin = require("telescope.builtin")
				map("<leader>sf", builtin.find_files, "파일 검색")
				map("<leader>sd", builtin.diagnostics, "진단 정보 검색")
				map("<leader>sw", builtin.grep_string, "현재 단어 검색")

				map("<leader>sg", builtin.live_grep, "라이브 텍스트 검색")
				map("K", vim.lsp.buf.hover, "문서 피드백 보기")
				map("<leader>li", vim.lsp.buf.implementation, "구현체 이동")

				map("<leader>rr", function()
					vim.lsp.buf.code_action({ context = { only = { "refactor" } } })
				end, "리팩토링 작업")
			end,
		})
	end,
}
