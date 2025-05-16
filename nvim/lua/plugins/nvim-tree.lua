return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local function label(path)
			path = path:gsub(os.getenv("HOME"), "~", 1)
			return path:gsub("([a-zA-Z])[a-z0-9]+", "%1") .. (path:match("[a-zA-Z]([a-z0-9]*)$") or "")
		end

		local nt = require("nvim-tree")
		local api = require("nvim-tree.api")
		local utils = require("core.utils")
		nt.setup({
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = true,
				debounce_delay = 50,
				severity = {
					min = vim.diagnostic.severity.HINT,
					max = vim.diagnostic.severity.ERROR,
				},
				icons = {
					hint = utils.get_icon_by_name("hint"),
					info = utils.get_icon_by_name("info"),
					warning = utils.get_icon_by_name("warn"),
					error = utils.get_icon_by_name("error"),
				},
			},
			renderer = {
				root_folder_label = label,
				group_empty = label,
				icons = {
					git_placement = "before",        -- Git 아이콘 위치 (before/after)
					modified_placement = "after",    -- 수정 표시 위치
					diagnostics_placement = "signcolumn", -- 진단 아이콘 위치
					glyphs = {
						git = {
							unstaged = "",
							staged = "",
							unmerged = "",
							renamed = "",
							untracked = "",
							deleted = "",
							ignored = "",
						},
					},
				},
				indent_markers = {
					enable = true,
				},
			},
			view = {
				float = {
					enable = true, -- 플로팅 창 활성화
					open_win_config = {
						relative = "editor",
						width = 40,   -- 창 너비
						height = 30,  -- 창 높이
						row = 5,      -- 편집기 상단에서의 행 위치
						col = 30,     -- 편집기 왼쪽에서의 열 위치
						border = "rounded", -- 둥근 테두리 스타일
					},
				},
			},
			actions = {
				open_file = {
					quit_on_open = true, -- 파일 선택 시 플로팅 창 자동 닫힘
				},
			},

			on_attach = function(bufnr)
				local function opts(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- 기본 매핑 전체 유지
				api.config.mappings.default_on_attach(bufnr)

				-- 커스텀 매핑 덮어쓰기
				vim.keymap.set("n", "h", function()
					local node = api.tree.get_node_under_cursor()
					if node.type == "directory" then
						if node.open then
							api.node.navigate.parent_close()
						else
							api.node.navigate.parent() -- 닫힌 폴더에서 상위 이동
						end
					else
						api.node.navigate.parent() -- 파일에서 상위 이동
					end
				end, opts("Toggle close or move parent"))

				vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
			end,
		})
	end,
}
