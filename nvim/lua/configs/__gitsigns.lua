local M = {}

function M.setup()
  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "↑-" },
      changedelete = { text = "±" },
      untracked = { text = "?" }
    },
    signcolumn = true, -- 깃 사인 컬럼 항상 표시
    numhl = false,     -- 라인 번호 하이라이트 비활성화
    linehl = false,    -- 라인 하이라이트 비활성화
    watch_gitdir = {
      interval = 1000, -- 깃 상태 체크 간격(ms)
      follow_files = true,
    },
    current_line_blame = true,       -- 현재 라인 변경 이력 표시
    current_line_blame_opts = {
      virt_text_pos = "right_align", -- 오른쪽 정렬
      delay = 500,                   -- 정보 표시 지연 시간
    },
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end)
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end)
      -- Actions

      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "현재 청크 스테이징" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "현재 청크 리셋" })

      map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "선택 영역 스테이징" })

      map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "선택 영역 리셋" })

      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "전체 파일 스테이징" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "전체 파일 리셋" })

      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "변경 사항 미리보기" })
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "인라인 변경 사항 미리보기" }) -- ※ 오타 수정 (hink → hunk)

      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "현재 라인 변경 이력" })

      map("n", "<leader>hd", gitsigns.diffthis, { desc = "현재 파일 diff 보기" })
      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, { desc = "마지막 커밋과 diff 보기" })

      map("n", "<leader>hQ", function()
        gitsigns.setqflist("all")
      end, { desc = "모든 변경 사항을 퀵픽스에 추가" })
      map("n", "<leader>hq", gitsigns.setqflist, { desc = "현재 변경 사항을 퀵픽스에 추가" })
    end,
  })
end

return M
