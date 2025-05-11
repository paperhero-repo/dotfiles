local M = {}

function M.setup()
	-- [[ Neo-tree 기본 설정 ]]
	require("neo-tree").setup({
		close_if_last_window = false, -- 마지막 창이어도 닫히지 않음
		popup_border_style = "rounded", -- 둥근 테두리 스타일
		enable_git_status = true, -- Git 상태 표시
		enable_diagnostics = true, -- 진단 정보 표시

		-- [[ 기본 컴포넌트 설정 ]]
		default_component_configs = {
			indent = {
				indent_size = 2, -- 들여쓰기 크기
				padding = 1, -- 왼쪽 여백
				indent_marker = "│", -- 들여쓰기 가이드 라인
				last_indent_marker = "└", -- 마지막 항목 표시 기호
				expander_collapsed = "", -- 접힌 폴더 아이콘
				expander_expanded = "", -- 펼쳐진 폴더 아이콘
			},
			icon = {
				folder_closed = "", -- 일반 폴더 아이콘
				folder_open = "", -- 열린 폴더 아이콘
				folder_empty = "󰜌", -- 빈 폴더 아이콘
			},
			git_status = {
				symbols = {
					added = "A", -- Added (추가됨)
					modified = "M", -- Modified (수정됨)
					deleted = "D", -- Deleted (삭제됨)
					renamed = "R", -- Renamed (이름 변경됨)
					untracked = "?", -- Untracked (추적되지 않음)
					ignored = "!", -- Ignored (무시됨)
					unstaged = "U", -- Unstaged (스테이징 안 됨)
					staged = "S", -- Staged (스테이징 됨)
					conflict = "C", -- Conflict (충돌 상태)
				},
			},
		},

		-- [[ 창 설정 ]]
		window = {
			position = "float", -- 오른쪽에 위치
			popup = {
				title = "Explorer", -- 원하는 제목으로 변경 [[1]]
			},
			width = 40, -- 창 너비
			mappings = { -- 키 매핑 설정
				["<space>"] = "toggle_node", -- 노드 토글
				["<cr>"] = "open", -- 파일 열기
				["S"] = "open_split", -- 수평 분할로 열기
				["s"] = "open_vsplit", -- 수직 분할로 열기
				["t"] = "open_tabnew", -- 새 탭에서 열기
				["a"] = "add", -- 파일/폴더 추가
				["d"] = "delete", -- 삭제
				["r"] = "rename", -- 이름 변경
				["q"] = "close_window", -- 창 닫기
				["l"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" and not node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					end
				end,
				["h"] = function(state)
					local node = state.tree:get_node()
					if node.type == "file" then
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					elseif node.type == "directory" then
						if node:is_expanded() then
							require("neo-tree.sources.filesystem").toggle_directory(state, node)
						else
							require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
						end
					end
				end,
			},
		},
		source_selector = {
			winbar = true,
			statusline = false,
			sources = { -- 소스 탭 순서를 여기에 정의 [[1]]
				{ source = "filesystem", display_name = "File" },
				{ source = "git_status", display_name = "Git" },
				{ source = "buffers", display_name = "Buf" },
			},
			tabs_layout = "end",
			highlight_tab = "FloatBorder",
			highlight_tab_active = "NormalFloat",
			highlight_background = " ",
			highlight_separator = "FloatBorder",
			highlight_separator_active = "FloatBorder",
		},

		-- [[ 파일 시스템 설정 ]]
		filesystem = {
			filtered_items = {
				hide_by_name = { -- 숨길 파일/폴더 목록
					".DS_Store",
					"thumbs.db",
					"node_modules",
					"__pycache__",
					".git",
					".venv",
				},
			},
			hijack_netrw_behavior = "open_default", -- netrw 대체
			use_libuv_file_watcher = false, -- 파일 감시기 설정
		},

		-- [[ 버퍼 관리 설정 ]]
		buffers = {
			follow_current_file = {
				enabled = true, -- 현재 파일 자동 추적
			},
		},

		-- [[ Git 상태 관리 설정 ]]
		git_status = {
			window = {
				position = "float", -- Git 상태창은 플로팅 창으로
				mappings = {
					["ga"] = "git_add_file", -- 파일 스테이징
					["gc"] = "git_commit", -- 커밋 생성
					["gp"] = "git_push", -- 푸시
				},
			},
		},
	})

	vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { link = "Special" })
end

return M
