-- 기본 설정 로드
require("core.options").setup()
require("core.neovide-options").setup()
require("core.keymaps").setup()

-- Set up the Lazy plugin manager
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
	require("plugins.__cmp"),
	require("plugins.__telescope"),
	require("plugins.__lspconfig"),
	require("plugins.__treesitter"),
	require("plugins.__hlchunk"),
	require("plugins.__snipe"),
	require("plugins.__gitsigns"),
	require("plugins.__none-ls"),
	require("plugins.__neotree"),
	require("plugins.__misc"),
	require("plugins.__trouble"),
	require("plugins.__noice"),
	require("plugins.__lualine"),
	require("plugins.__comment"),
})

require("core.snippets").setup()
