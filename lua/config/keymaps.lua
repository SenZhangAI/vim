local map = vim.keymap.set

-- LSP keymaps (set in lsp.lua on_attach, but global diagnostic nav here)
map("n", "[g", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]g", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

-- [b ]b / [q ]q / [l ]l 是 nvim 0.11+ 内置映射, 无需再定义

-- Terminal toggle (Ctrl+J, aligns with VS Code Ctrl+J/Cmd+J)
local function toggle_terminal()
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
end
map("n", "<C-j>", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<C-j>", toggle_terminal, { desc = "Toggle terminal" })

-- Quickfix toggle
map("n", "yoq", function()
  local wins = vim.fn.getqflist({ winid = 0 }).winid
  if wins ~= 0 then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle quickfix" })

-- 撤销历史树: nvim 0.12 内置 (取代 undotree 插件)
map("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd("Undotree")
end, { desc = "Toggle undo tree" })
