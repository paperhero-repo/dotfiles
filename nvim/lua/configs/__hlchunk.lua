local M = {}

function M.setup()
  require("hlchunk").setup({
    indent = {
      enable = true,
      use_treesitter = true,
      chars = {
        "┊", -- Depth 4
      },
    },
    chunk = {
      enable = true,
      duration = 100,
      delay = 50,
    },
  })
end

return M
