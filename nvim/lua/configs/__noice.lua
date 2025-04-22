local M = {}

function M.setup()
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			documentation = {
				view = "hover", -- LSP 문서 플로팅 창
				opts = {
					size = {
						width = "auto",
						height = "auto",
						min_width = 40,
						max_width = 50,
					},
					border = {
						style = "rounded",
						text = {
							top = " Documentation ",
						},
					},
				},
			},
		},
		presets = {
			lsp_doc_border = true, -- LSP 문서 테두리 활성화
			command_palette = true, -- Telescope 스타일 팔레트
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					kind = "search_count",
				},
				opts = { skip = true },
			},
		},

		-- you can enable a preset for easier configuration
	})
end

return M
