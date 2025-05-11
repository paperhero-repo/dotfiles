local M = {}

function M.setup()
	require("Comment").setup({})

	local map = vim.keymap.set
	map("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "지금 라인 코멘트" })
	map("x", "<leader>/", "<Plug>(comment_toggle_blockwise_visual)", { desc = "선택 라인 코멘트" })
end

return M
