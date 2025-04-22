local M = {}

function M.setup()
	require("trouble").setup({
		modes = {
			diagnostics = {
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.3,
				},
			},
		},
	})
end

return M
