return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
	},
	config = function()
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
	end,
}
