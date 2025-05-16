return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitsigns").setup({
      signs = {
        symbols = {
          added = "│", -- 세로 막대
          modified = "─", -- 가로 막대
          removed = "─", -- 가로 막대
        },
        add = { text = "│" }, -- 추가된 라인 (세로 막대)
        change = { text = "─" }, -- 변경된 라인 (가로 막대)
        delete = { text = "─" }, -- 삭제된 라인 (가로 막대)
        topdelete = { text = "▴" }, -- 상단 삭제 (삼각형)
        changedelete = { text = "╌" }, -- 변경+삭제 (이중 가로 막대)
        untracked = { text = "┆" }, -- 추적되지 않은 파일 (점선 막대)
      },
      signcolumn = true, -- 깃 사인 컬럼 항상 표시
      numhl = false, -- 라인 번호 하이라이트 비활성화
      linehl = false, -- 라인 하이라이트 비활성화
      watch_gitdir = {
        interval = 1000, -- 깃 상태 체크 간격(ms)
        follow_files = true,
      },
      current_line_blame = true,       -- 현재 라인 변경 이력 표시
      current_line_blame_opts = {
        virt_text_pos = "right_align", -- 오른쪽 정렬
        delay = 500,                   -- 정보 표시 지연 시간
      },
    })
  end,
}
