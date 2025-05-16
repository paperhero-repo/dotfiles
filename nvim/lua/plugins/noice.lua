return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"muniftanjim/nui.nvim",
	},
	config = function()
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

			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {
					win_options = {
						winhighlight = {
							Normal = "NormalFloat",
							FloatBorder = "FloatBorder",
							FloatTitle = "FloatNormal",
							NoiceCmdlineIcon = "FloatNormal",
						},
					},
				},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
				},
			},
			views = {
				cmdline_popupmenu = { -- 자동 완성 메뉴 스타일
					relative = "editor",
					win_options = {
						winhighlight = {
							Normal = "NormalFloat",
							FloatBorder = "FloatBorder",
							CursorLine = "Visual",
							PmenuSel = "WildMenu",
						},
					},
				},
			},

			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true,
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
		})
	end,
}
