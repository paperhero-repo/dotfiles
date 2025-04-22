return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	config = function()
		require("configs.__neotree").setup()

		local map = require("core.utils").make_map("Tree:")
		vim.cmd([[nnoremap \ :Neotree reveal<cr>]]) -- \ 키로 트리 토글
		map("<leader>e", ":Neotree toggle<CR>", "트리 토글") -- 리더+e로 트리 열기/닫기
		map("<leader>ngs", ":Neotree float git_status<CR>", "Git 상태창 열기") -- Git 상태 표시
	end,
}
