local M = {}

function M.setup()
	local opts = { noremap = true, silent = true }

	-- 기본 키맵 최적화
	vim.keymap.set("n", "x", '"_x', opts) -- 삭제 시 레지스터 저장 안함

	-- 스크롤 시 화면 중앙 유지
	vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
	vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

	-- 시스템 클립보드 통합 (macOS)
	vim.keymap.set({ "n", "v" }, "<D-c>", '"+y', { desc = "시스템 클립보드로 복사" })
	vim.keymap.set({ "n", "i" }, "<D-v>", '"+p', { desc = "시스템 클립보드에서 붙여넣기" })
	vim.keymap.set("n", "<D-C-c>", ":%y+<CR>", { desc = "전체 파일 내용 복사" })
	vim.keymap.set("v", "<D-x>", '"+x', { desc = "선택 영역 잘라내기" })

	-- 터미널 모드 클립보드 지원
	vim.keymap.set("t", "<D-v>", [[<C-\><C-n>"+p]], { desc = "터미널 모드에서 붙여넣기" })

	-- 진단(Diagnostics) 키맵 (최신 API 반영)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ float = false }) -- 부동 창 없이 이동
	end, { desc = "이전 진단 메시지로 이동" })

	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ float = false }) -- 부동 창 없이 이동
	end, { desc = "다음 진단 메시지로 이동" })

	vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "진단 메시지 부동 창 열기" })
	vim.keymap.set(
		"n",
		"<leader>q",
		vim.diagnostic.setloclist,
		{ desc = "진단 목록 로케이션리스트에 표시" }
	)

	-- Neovide GUI 전용 설정
	if vim.g.neovide then
		vim.keymap.set("n", "<D-=>", function()
			vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.2
		end, { desc = "UI 크기 확대" })

		vim.keymap.set("n", "<D-->", function()
			vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.2
		end, { desc = "UI 크기 축소" })
	end
end

return M
