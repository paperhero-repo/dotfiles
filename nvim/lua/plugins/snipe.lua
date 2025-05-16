return {
	"leath-dub/snipe.nvim",
	config = function()
		local utils = require("core.utils")
		require("snipe").setup({
			ui = {
				position = "cursor",
				open_win_override = {
					title = " " .. utils.get_icon_by_name("buffer") .. " ",
					title_pos = "center",
					border = "rounded",
				},
				cursorline = true,
				preselect_current = true,
				text_align = "right",
				filename = "a",
				buffer_format = {
					function(snipe_buf_obj)
						local bufnr = snipe_buf_obj.id
						local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
						local name = vim.api.nvim_buf_get_name(snipe_buf_obj.id)

						-- 터미널 버퍼 처리
						if buftype == "terminal" then
							name = "term://"
						end

						-- 일반 파일 처리
						if name == "" then
							name = "[No Name]"
						end

						if buftype == "" then
							local short_path = vim.fn.fnamemodify(name, ":~:.")
							name = short_path
						end

						if #name < 20 then
							name = string.format("%20s", name)
						end

						return name
					end,
					function(snipe_buf_obj)
						local count =
								#vim.diagnostic.get(snipe_buf_obj.id, { severity = vim.diagnostic.severity.ERROR })
						return count > 0 and " " .. utils.get_icon_by_name("error") or "", "DiagnosticError"
					end,
					function(snipe_buf_obj)
						local count = #vim.diagnostic.get(snipe_buf_obj.id, { severity = vim.diagnostic.severity.WARN })
						return count > 0 and " " .. utils.get_icon_by_name("warn") or "", "DiagnosticWarn"
					end,
					function(snipe_buf_obj)
						return vim.api.nvim_get_option_value("modified", { buf = snipe_buf_obj.id }) and "[+]" or ""
					end,
				},
			},
			hints = {
				dictionary = "01234qwerasdfzxcv",
			},
			sort = "last",
		})
	end,
}
