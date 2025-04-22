local M = {}

function M.setup()
	-- 하이라이트 우선순위 설정 (LSP 시맨틱 토큰 우선순위)
	vim.highlight.priorities.semantic_tokens = 95 -- 기본값 100보다 낮게 설정

	-- 진단 메시지 설정 (LSP, linter 등에서 발생하는 에러/경고 표시)
	vim.diagnostic.config({
		virtual_text = true,
		update_in_insert = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = "",
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
end

return M
