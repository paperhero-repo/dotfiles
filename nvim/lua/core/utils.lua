local M = {}

--- 프로젝트 루트 디렉토리 탐지
-- 지원하는 프로젝트 마커를 기반으로 현재 파일의 프로젝트 루트 경로 탐색
-- @return string 프로젝트 루트 경로 (탐지 실패 시 현재 작업 디렉토리 반환)
function M.detect_project_root()
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		current_file = vim.fn.getcwd()
	end

	-- 프로젝트 마커 목록 (확장 가능)
	local markers = {
		".git", -- Git 저장소
		"go.mod", -- Go 프로젝트
		"pubspec.yaml", -- Flutter 프로젝트
		"package.json", -- Node.js/SvelteKit 프로젝트
		"svelte.config.js", -- Svelte 프로젝트
		"Cargo.toml", -- Rust 프로젝트
		"CMakeLists.txt", -- C/C++ 프로젝트
		"mix.exs", -- Elixir 프로젝트
		"pyproject.toml", -- Python 프로젝트
	}

	--- 재귀적으로 상위 디렉토리 탐색
	-- @param path string 탐색 시작 경로
	-- @return string|nil 발견된 루트 경로 또는 nil
	local function find_root(path)
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			return nil -- 파일 시스템 루트 도달
		end

		-- 현재 경로에서 마커 검사
		for _, marker in ipairs(markers) do
			local check_path = vim.fn.glob(path .. "/" .. marker)
			if check_path ~= "" then
				return path
			end
		end

		return find_root(parent) -- 상위 디렉토리로 재귀 탐색
	end

	return find_root(vim.fn.fnamemodify(current_file, ":h")) or vim.fn.getcwd()
end

--- 윈도우 크기 조정
-- 화면 크기에 맞게 동적 크기 조정
-- @param size number 원하는 크기
-- @return number 조정된 크기
function M.set_size(size)
	local screen_height = vim.api.nvim_win_get_height(0)
	-- 화면 여유 공간 고려 (10줄 이상 여유 있을 때만 원하는 크기 사용)
	if screen_height > size + 10 then
		return size
	else
		return screen_height -- 화면 크기에 맞춤
	end
end

--- 현재 윈도우 화면 크기 조회
-- @return table {width: number, height: number} 형태의 크기 정보
function M.get_screen_size()
	return {
		width = vim.api.nvim_win_get_width(0) or 0,
		height = vim.api.nvim_win_get_height(0) or 0,
	}
end

--- 키맵 생성 헬퍼 함수
-- @param prefix string 키맵 설명 접두사
-- @param buf number 버퍼 번호 (nil일 경우 글로벌 키맵)
-- @return function(map_keys: string, func: function, desc: string, mode?: string)
function M.make_map(prefix, buf)
	--- 내부 키맵 설정 함수
	-- @param keys string 키 조합
	-- @param func function 매핑될 함수
	-- @param desc string 키맵 설명
	-- @param mode string 모드 (기본값: "n")
	local function map(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, {
			buffer = buf,
			desc = prefix .. desc, -- 접두사 + 설명 조합
			noremap = true,
			silent = true,
		})
	end
	return map
end
return M
