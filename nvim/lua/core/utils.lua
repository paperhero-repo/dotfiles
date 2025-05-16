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
		".git",           -- Git 저장소
		"go.mod",         -- Go 프로젝트
		"pubspec.yaml",   -- Flutter 프로젝트
		"package.json",   -- Node.js/SvelteKit 프로젝트
		"svelte.config.js", -- Svelte 프로젝트
		"Cargo.toml",     -- Rust 프로젝트
		"CMakeLists.txt", -- C/C++ 프로젝트
		"mix.exs",        -- Elixir 프로젝트
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

function M.get_icon_by_name(name)
	local icons = {
		-- LSP 진단 아이콘 (Nerd Font)
		error = " ",
		warn = " ",
		info = " ",
		hint = " ",

		-- 버퍼 수정 상태 아이콘
		modi = "+",

		-- Git 상태 아이콘 (Nerd Font)
		git_added = " ",
		git_modified = " ",
		git_removed = " ",
	}

	return icons[name] or "?"
end

return M
