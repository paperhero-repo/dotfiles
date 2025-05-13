-- lua/configs/__keymap.lua
local M = {}

function M.setup()
	local map = function(mode, l, r, opts)
		opts = opts or {}
		opts.silent = true
		opts.noremap = true
		vim.keymap.set(mode, l, r, opts)
	end

	map("n", "<leader><leader>", function()
		local api = require("snipe")
		api.open_buffer_menu()
	end, { desc = "버퍼선택기" })

	-- 기본 편집 최적화 --
	----------------------
	-- 삭제 시 레지스터 저장 방지
	map("n", "x", '"_x')

	-- 스크롤 시 화면 중앙 유지
	map("n", "<C-d>", "<C-d>zz")
	map("n", "<C-u>", "<C-u>zz")

	-- 시스템 클립보드 통합 (macOS) --
	--------------------------------
	-- 일반/비주얼 모드
	map({ "n", "v" }, "<D-c>", '"+y')
	map({ "n", "i" }, "<D-v>", '"+p')
	map("n", "<D-C-c>", ":%y+<CR>")
	map("v", "<D-x>", '"+x')

	-- 터미널 모드 클립보드
	map("t", "<D-v>", [[<C-\><C-n>"+p]])

	map("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "지금 라인 코멘트" })
	map("x", "<leader>/", "<Plug>(comment_toggle_blockwise_visual)", { desc = "선택 라인 코멘트" })

	local diag = require("vim.diagnostic")
	local function jump_diagnostic(count)
		diag.jump({ count = count, float = false })
	end

	map("n", "<leader>tp", function()
		jump_diagnostic(-1)
	end, { desc = "이전 진단 이동" })
	map("n", "<leader>tn", function()
		jump_diagnostic(1)
	end, { desc = "다음 진단 이동" })

	map("n", "<leader>tl", function()
		diag.open_float({
			scope = "line", -- 커서 위치 라인 기준
			border = "rounded",
			prefix = function(d)
				return string.format("(%d) ", d.severity)
			end,
		})
	end, { desc = "진단 메시지 표시" })

	map("n", "<leader>tq", diag.setloclist, { desc = "로케이션리스트에 진단 표시" })

	-- Neovide GUI 설정 --
	----------------------
	if vim.g.neovide then
		local function scale_gui(factor)
			return function()
				vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
			end
		end

		map("n", "<D-=>", scale_gui(1.2))
		map("n", "<D-->", scale_gui(1 / 1.2))
	end

	-- 모드(mode) 매개변수 추가 및 옵션 테이블 정리
	map("n", "<leader>f", ":Neotree toggle<CR>", { desc = "트리 토글" })

	local telescope_builtin = require("telescope.builtin")
	-- Telescope 기능
	map("n", "<leader>sf", telescope_builtin.find_files, { desc = "파일 검색" })
	map("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "진단 정보 검색" })
	map("n", "<leader>sw", telescope_builtin.grep_string, { desc = "현재 단어 검색" })
	map("n", "<leader>sg", telescope_builtin.live_grep, { desc = "라이브 텍스트 검색" })

	vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("gitsigns-attach", { clear = true }),
		callback = function(event)
			local gitsigns = require("gitsigns")
			map("n", "g]", function()
				if vim.wo.diff then
					vim.cmd.normal({ "g]", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)
			map("n", "g[", function()
				if vim.wo.diff then
					vim.cmd.normal({ "g[", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)
			-- Actions

			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "현재 청크 스테이징", buffer = event.buf })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "현재 청크 리셋", buffer = event.buf })

			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "선택 영역 스테이징", buffer = event.buf })

			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "선택 영역 리셋", buffer = event.buf })

			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "전체 파일 스테이징", buffer = event.buf })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "전체 파일 리셋", buffer = event.buf })

			map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "변경 사항 미리보기", buffer = event.buf })
			map(
				"n",
				"<leader>gi",
				gitsigns.preview_hunk_inline,
				{ desc = "인라인 변경 사항 미리보기", buffer = event.buf }
			) -- ※ 오타 수정 (hink → hunk)

			map("n", "<leader>gb", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "현재 라인 변경 이력", buffer = event.buf })

			map("n", "<leader>gd", gitsigns.diffthis, { desc = "현재 파일 diff 보기", buffer = event.buf })
			map("n", "<leader>gD", function()
				gitsigns.diffthis("~")
			end, { desc = "마지막 커밋과 diff 보기", buffer = event.buf })

			map("n", "<leader>gQ", function()
				gitsigns.setqflist("all")
			end, { desc = "모든 변경 사항을 퀵픽스에 추가", buffer = event.buf })
			map(
				"n",
				"<leader>gq",
				gitsigns.setqflist,
				{ desc = "현재 변경 사항을 퀵픽스에 추가", buffer = event.buf }
			)
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf

			-- LSP 기본 기능
			map("n", "<leader>cd", vim.lsp.buf.definition, { desc = "정의로 이동", buffer = buf })
			map("n", "<leader>cr", function()
				telescope_builtin.lsp_references({
					include_declaration = false, -- 선언부 제외 (선택 사항)
					show_line = true,        -- 코드 라인 표시
					path_display = { "shorten" }, -- 파일 경로 축약 표시
				})
			end, { desc = "참조 검색", buffer = buf })
			map("n", "<leader>cn", vim.lsp.buf.rename, { desc = "심볼 이름 변경", buffer = buf })
			map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "코드 작업 실행", buffer = buf })
			map("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "선언부 이동", buffer = buf })
			map("n", "<leader>ck", vim.lsp.buf.hover, { desc = "문서 피드백 보기", buffer = buf })
			map("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "구현체 이동", buffer = buf })
			map("n", "<leader>cf", function()
				vim.lsp.buf.code_action({ context = { only = { "refactor" } } })
			end, { desc = "리팩토링 작업", buffer = buf })
		end,
	})

	map("n", "<leader>bn", function()
		vim.cmd.enew()
	end, { desc = "새로운 버퍼 생성" })

	map("n", "<leader>bt", function()
		vim.cmd.enew()
		vim.cmd.terminal()

		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
	end, { desc = "터미널" })

	map("n", "<leader>bax", function() -- 추가된 기능
		-- 현재 버퍼를 제외한 모든 버퍼 닫기
		local current_buf = vim.api.nvim_get_current_buf()
		local buffers = vim.api.nvim_list_bufs()

		for _, buf in ipairs(buffers) do
			if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
				vim.api.nvim_buf_delete(buf, {})
			end
		end
	end, { desc = "다른 버퍼 모두 닫기" })

	map("n", "<leader>bx", function() -- 추가된 기능
		-- 현재 버퍼 닫기 (창 닫지 않고 유지)
		local buf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { desc = "현재 버퍼 닫기" })

	map("n", "<leader>pr", "<cmd>SetProjectRoot <cr>", { desc = "루트찾기" })

	require("which-key").setup({
		preset = "helix",
		delay = 0,
		height = math.huge,
		icons = {
			mappings = false, -- disable icons in keymaps
		},
		sort = { "alphanum" },
		spec = {
			{ "<leader>t", group = "문제/진단" },
			{ "<leader>g", group = "Git" },
			{ "<leader>s", group = "검색" },
			{ "<leader>c", group = "코드" },
			{ "<leader>b", group = "버퍼" },
			{ "<leader>p", group = "프로젝트" },
		},
	})
end

return M
