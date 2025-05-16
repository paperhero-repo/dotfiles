return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local function hide_in_width()
			return vim.fn.winwidth(0) > 100
		end

		local utils = require("core.utils")

		local components = {
			mode = {
				"mode",
				fmt = function(_)
					return "₍^. .^₎⟆"
				end,
			},

			filename = {
				function()
					-- 터미널 버퍼 체크
					if vim.bo.buftype == "terminal" then
						return "term://" -- nerd font 아이콘 + 텍스트
					end

					-- 일반 파일 처리
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
					if filename == "" then
						return "[No Name]"
					end

					-- 파일 상태 아이콘 추가
					local modified = vim.bo.modified and string.format("[%s]", utils.get_icon_by_name("modi")) or ""
					return filename .. modified
				end,
				cond = function() -- 너비가 충분할 때만 표시
					return vim.fn.winwidth(0) > 70
				end,
			},

			buffer_count = {
				function()
					-- 버퍼 정보 가져오기 (listed=1: 버퍼 목록에 표시되는 것만, loaded=1: 로드된 버퍼만)
					local buffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
					buffers = vim.tbl_filter(function(b)
						return b.listed == 1 and b.loaded == 1
					end, buffers)
					return " " .. #buffers
				end,
				cond = hide_in_width,
			},

			lsp = {
				function()
					local buf_ft = vim.bo.filetype
					local clients = vim.lsp.get_clients()
					if #clients == 0 then
						return "No Active Lsp"
					end

					for _, client in ipairs(clients) do
						---@diagnostic disable-next-line: undefined-field
						if client.config.filetypes and vim.tbl_contains(client.config.filetypes, buf_ft) then
							return client.name
						end
					end
					return "No Active Lsp"
				end,
			},

			diagnostics = {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = {
					error = utils.get_icon_by_name("error"),
					warn = utils.get_icon_by_name("warn"),
					info = utils.get_icon_by_name("info"),
					hint = utils.get_icon_by_name("hint"),
				},
				colored = true,
				update_in_insert = false,
				always_visible = false,
				cond = hide_in_width,
			},

			diff = {
				"diff",
				colored = true,
				symbols = {
					added = utils.get_icon_by_name("git_added"),
					modified = utils.get_icon_by_name("git_modified"),
					removed = utils.get_icon_by_name("git_removed"),
				},
				cond = hide_in_width,
			},
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree" },
				always_divide_middle = true,
			},

			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "branch", components.diff },
				lualine_x = { { "encoding", cond = hide_in_width }, "location", "progress" },
				lualine_y = {},
				lualine_z = {},
			},

			inactive_sections = {
				lualine_c = { components.filename },
			},

			tabline = {
				lualine_a = {
					components.mode,
				},
				lualine_b = { components.buffer_count },
				lualine_c = { components.filename },
				lualine_x = { components.diagnostics },
				lualine_y = { components.lsp },
				lualine_z = {
					{ "filetype", cond = hide_in_width, colored = false },
				},
			},

			extensions = { "fugitive" },
		})
	end,
}
