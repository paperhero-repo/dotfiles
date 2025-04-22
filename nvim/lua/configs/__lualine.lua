local M = {}

function M.setup()
	local hide_in_width = function()
		return vim.fn.winwidth(0) > 100
	end

	local mode = {
		"mode",
		fmt = function(str)
			return " " .. str:sub(1, 1)
		end,
	}

	local filename = {
		"filename",
		file_status = true, -- displays file status (readonly status, modified status)
		path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
	}

	local buffer_count = {
		function()
			local bufs_out = vim.api.nvim_exec2("ls", { output = true }).output
			local bufs = vim.split(bufs_out, "\n", { trimempty = true })
			return " " .. #bufs
		end,
		cond = hide_in_width, -- 필요에 따라 조건 추가/제거
	}

	local lsp = {
		function()
			local msg = "No Active Lsp"
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
			local clients = vim.lsp.get_clients()
			if next(clients) == nil then
				return msg
			end
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					return client.name
				end
			end
			return msg
		end,
		icon = " ",
	}

	local diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		sections = { "error", "warn", "info", "hint" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		colored = true,
		update_in_insert = false,
		always_visible = false,
		cond = hide_in_width,
	}

	local diff = {
		"diff",
		colored = false,
		symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
		cond = hide_in_width,
	}

	require("lualine").setup({
		options = {
			icons_enabled = true,
			--			theme = "nord", -- Set theme based on environment variable
			theme = function()
				local lualine_theme = require("lualine.themes.kanagawa-paper-ink")

				local colors = require("kanagawa-paper.colors").setup({ _theme = "ink" })
				local theme = colors.theme

				lualine_theme.normal.c = { fg = "", bg = theme.ui.bg }
				lualine_theme.inactive.c = { fg = "", bg = theme.ui.bg }

				return lualine_theme
			end,
			section_separators = { left = "", right = "" },
			component_separators = { left = "·", right = "·" },
			disabled_filetypes = { "alpha", "neo-tree" },
			always_divide_middle = true,
		},
		sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{ "branch", diff },
			},
			lualine_x = {
				{ "encoding", cond = hide_in_width },
				"location",
				"progress",
			},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_a = { mode },
			lualine_b = {
				buffer_count,
			},
			lualine_c = { filename },
			lualine_x = {
				diagnostics,
			},
			lualine_y = {
				lsp,
			},
			lualine_z = {
				{ "filetype", cond = hide_in_width },
			},
		},
		inactive_tabline = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		extensions = { "fugitive" },
	})
end

return M
