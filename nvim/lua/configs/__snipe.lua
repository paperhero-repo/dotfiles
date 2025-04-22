local M = {}

function M.setup()
	require("snipe").setup({
		ui = {
			position = "cursor",
			open_win_override = {
				title = "Buffers",
				border = "rounded",
			},
			preselect_current = true,
			text_align = "right",
			title = "Buffers",
		},
		hints = {
			dictionary = "01234qwerasdfzxcv",
		},
		sort = "last",
	})
end

return M
