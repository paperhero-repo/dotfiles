local M = {}

function M.setup()
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			file_ignore_patterns = { "node_modules", ".git", ".venv", "build", "target" },
			layout_strategy = "vertical",
			layout_config = {
				mirror = false,
				preview_cutoff = 1,
				prompt_position = "bottom",
			},
			lsp_definitions = {
				position_params = vim.lsp.util.make_position_params(0, "utf-8"),
			},
		},
		pickers = {
			find_files = {
				find_files = {
					hidden = true,
					find_command = {
						"fd",
						"--type=file",
						"--hidden",
						"--exclude=.git",
						"--exclude=node_modules",
						"--exclude=.dart_tool",
						"--exclude=.pub-cache",
						"--exclude=build",
						"--exclude=target",
					},
				},
				live_grep = {
					additional_args = function(_)
						return { "--hidden", "--glob=!**/.git/*", "--glob=!**/node_modules/*" }
					end,
				},
			},
		},
		extensions = {
			["ui-select"] = require("telescope.themes").get_dropdown(),
		},
	})

	pcall(telescope.load_extension, "fzf")
	pcall(telescope.load_extension, "ui-select")
	vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
	vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "FloatBorder" })

	vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { link = "NormalFloat" })

	vim.api.nvim_set_hl(0, "TelescopeTitle", { link = "Special" })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { link = "Special" })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { link = "Special" })

	vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "Visual" })
end

return M
