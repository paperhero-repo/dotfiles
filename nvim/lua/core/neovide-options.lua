local M = {}

function M.setup()
	-- Neovide GUI 설정
	if vim.g.neovide then
		-- 글꼴 설정 (시스템에 설치된 폰트 사용)
		vim.o.guifont = "JetBrains Mono,FiraCode Nerd Font:h16" -- 폰트/크기 설정
		vim.g.neovide_font_antialiasing = true -- 안티앨리어싱 활성화
		vim.g.neovide_opacity = 0.98
		vim.g.neovide_normal_opacity = 0.75
		vim.g.neovide_show_border = true
		vim.g.neovide_window_blurred = true
		vim.g.neovide_no_idle = true
		vim.g.neovide_cursor_vfx_mode = { "pixiedust" }
		vim.g.neovide_refresh_rate = 144
	end
end

return M
