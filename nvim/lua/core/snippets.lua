local M = {}

function M.setup()
	local utils = require("core.utils")
	-- 하이라이트 우선순위 설정 (LSP 시맨틱 토큰 우선순위)
	vim.highlight.priorities.semantic_tokens = 95 -- 기본값 100보다 낮게 설정

	-- 진단 메시지 설정 (LSP, linter 등에서 발생하는 에러/경고 표시)
	vim.diagnostic.config({
		virtual_text = true,
		update_in_insert = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = utils.get_icon_by_name("error"),
				[vim.diagnostic.severity.WARN] = utils.get_icon_by_name("warn"),
				[vim.diagnostic.severity.INFO] = utils.get_icon_by_name("info"),
				[vim.diagnostic.severity.HINT] = utils.get_icon_by_name("hint"),
			},
		},
		float = {
			border = "rounded",
			format = function(d)
				return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
			end,
		},
		underline = true,
		jump = {
			float = true,
		},
		severity_sort = true,
	})

	-- 야크(복사) 하이라이트 설정 (텍스트 복사시 일시적 하이라이트)
	local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank({
				higroup = "IncSearch", -- 사용할 하이라이트 그룹
				timeout = 300, -- 300ms 동안 유지
			})
		end,
		group = highlight_group,
		pattern = "*",
	})

	local colors = require("kanagawa-paper.colors").setup({ _theme = "ink" })
	local theme = colors.theme
	local visual_bg = theme.ui.bg_cursorline_alt
	local cursorline_bg = theme.ui.bg_cursorline
	--[[ vim.api.nvim_set_hl(0, "Visual", { bg = cursorline_bg })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = visual_bg }) ]]

	vim.keymap.set("n", "<leader>x", function()
		if vim.bo.modified then
			local choice =
				vim.fn.confirm("저장하지 않은 변경사항이 있습니다. 닫을까요?", "&Yes\n&No", 2)
			if choice == 1 then
				vim.cmd("bdelete!")
			end
		else
			vim.cmd("bdelete!")
		end
	end, { desc = "버퍼 닫기" })

	vim.api.nvim_create_user_command("SetProjectRoot", function()
		local path = utils.detect_project_root()

		if not path then
			vim.notify("프로젝트 루트를 찾을 수 없습니다 ", vim.log.lelves.ERROR)
			return
		end

		local choice =
			vim.fn.confirm("프로젝트 루트를 다음으로 설정하시겠습니까?\n" .. path, "&Yes\n&No", 2)

		if choice == 1 then
			vim.api.nvim_set_current_dir(path)
			vim.notify("설정완료: " .. path, vim.log.levels.INFO)
		else
			vim.notify("취소되었습니다.", vim.log.levels.WARN)
		end
	end, {})

	vim.api.nvim_create_user_command("GetTerminalPath", function()
		local handle = io.popen("pwd")
		if handle ~= nil then
			local path = handle:read("*a"):gsub("\n", "")
			handle:close()

			print(path)
			return
		end
		print("Not Found Handle")
	end, {})

	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		callback = function()
			if vim.fn.argc() == 0 then
				local path = "~/Works/"
				vim.api.nvim_set_current_dir(path)
			end
		end,
	})

	vim.api.nvim_create_user_command("SyncTerminalCwd", function()
		local jobid = vim.b.terminal_job_id
		if jobid == nil then
			vim.notify("버퍼가 터미널이여야 합니다.", vim.log.levels.ERROR)
			return
		end
		local os_name = vim.loop.os_uname().sysname

		local pid = vim.fn.jobpid(jobid)
		local cmd = os_name == "Darwin" and "lsof -p %d | grep cwd | awk '{print $9}'" or "readlink -f /proc/%d/cwd"
		local cwd = vim.fn.system(string.format(cmd, pid)):gsub("\n", "")

		vim.api.nvim_set_current_dir(cwd)

		vim.notify("루트변경: " .. cwd, vim.log.levels.INFO)
	end, {})
end

return M
