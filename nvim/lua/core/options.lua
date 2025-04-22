local M = {}

function M.setup()
	vim.opt.clipboard:append("unnamedplus") -- 시스템 클립보드와 레지스터 통합

	-- UI 설정
	vim.opt.number = true -- 라인 넘버 표시
	vim.opt.relativenumber = true -- 상대 라인 넘버
	vim.opt.cursorline = true -- 현제 커서 라인 하이라이트
	vim.opt.termguicolors = true -- 트루 컬러 지원
	vim.opt.scrolloff = 8 -- 스크롤 여백 설정
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.opt.signcolumn = "yes:2"
	vim.o.pumheight = 10 -- 자동완성 팝업 최대 높이
	vim.o.updatetime = 250 -- 플러그인 반응 속도(ms)

	-- 탭 & 인덴트
	vim.opt.tabstop = 2 -- 탭 문자 너비
	vim.opt.shiftwidth = 2 -- 자동 인덴트시 사용할 공백 수
	vim.opt.expandtab = true -- 탭을 공백으로 변환
	vim.opt.smartindent = true -- 상황별 스마트 인덴트

	-- 검색 설정
	vim.opt.ignorecase = true -- 검색 시 대소문자 무시
	vim.opt.smartcase = true -- 대문자 포함 시 대문자 구분
	vim.opt.hlsearch = true -- 검색 하이라이트
	vim.opt.incsearch = true -- 점진적 검색

	-- 파일 처리
	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.undofile = true
	vim.opt.autoread = true

	-- 기타 유용한 설정
	vim.opt.mouse = "a" -- 마우스 지원
	vim.opt.splitright = true -- 수직 분활 시 오른쪽에 생성
	vim.opt.splitbelow = true -- 수평 분활 시 아래에 생성
	vim.opt.wrap = false -- 줄 바꿈 비활성
	vim.o.completeopt = "menuone,noselect" -- 자동완성 동작
	vim.opt.shortmess:append("c") -- 완성 메시지 간소화

	vim.g.mapleader = " "

	vim.opt.titlestring = "N"
end

return M
