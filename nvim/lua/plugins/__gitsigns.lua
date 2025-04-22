return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require("configs.__gitsigns").setup()
  end
}
