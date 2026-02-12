local map = vim.keymap.set

-- LSP keymaps (set in lsp.lua on_attach, but global diagnostic nav here)
map("n", "[g", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Buffer navigation (replaces vim-unimpaired [b/]b)
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Quickfix navigation (replaces vim-unimpaired [q/]q)
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

-- Location list navigation
map("n", "[l", "<cmd>lprevious<cr>", { desc = "Prev loclist" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Next loclist" })

-- Terminal toggle (replaces vim-repl)
map("n", "<leader>ee", function()
  local buf_list = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buf_list) do
    if vim.bo[buf].buftype == "terminal" then
      local wins = vim.fn.win_findbuf(buf)
      if #wins > 0 then
        vim.api.nvim_win_close(wins[1], true)
        return
      end
    end
  end
  vim.cmd("botright split | terminal")
  vim.cmd("resize 15")
end, { desc = "Toggle terminal" })

-- Quickfix toggle
map("n", "yoq", function()
  local wins = vim.fn.getqflist({ winid = 0 }).winid
  if wins ~= 0 then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix" })
