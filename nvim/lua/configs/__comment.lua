local M = {}

function M.setup()
	require("Comment").setup({})

	local map = require("core.utils").make_map("Comment: ")
	map("<leader>/", "<Plug>(comment_toggle_linewise_current)", "지금 라인 코멘트")
	map("<leader>/", "<Plug>(comment_toggle_blockwise_visual)", "선택 라인 코멘트", "x")
end

return M
