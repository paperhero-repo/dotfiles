return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  main = 'nvim-treesitter.configs',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects', -- 텍스트 객체 확장
    'nvim-treesitter/playground'                   -- 구문 트리 시각화 (선택)
  },
  config = function()
    require("configs.__treesitter").setup()
  end
}
