-- 기본 설정 로드
require("core.options").setup()
require("core.neovide-options").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- 플러그인 관리자 초기화
require("lazy").setup({
	require("plugins.vim-sleuth"),
	require("plugins.vim-fugitive"),
	require("plugins.vim-rhubarb"),
	require("plugins.nvim-autopairs"),
	require("plugins.todo-comments"),
	require("plugins.nvim-colorizer"),
	require("plugins.which-key"),
	require("plugins.cmp"),
	require("plugins.telescope"),
	require("plugins.lspconfig"),
	require("plugins.treesitter"),
	require("plugins.hlchunk"),
	require("plugins.snipe"),
	require("plugins.gitsigns"),
	require("plugins.none-ls"),
	require("plugins.lualine"),
	require("plugins.comment"),
	require("plugins.noice"),
	require("plugins.nvim-tree"),
	require("theme.sakura"),
})

require("core.snippets").setup()
require("core.keymaps").setup()
