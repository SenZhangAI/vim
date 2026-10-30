-- snacks.nvim 一个插件替代 telescope / alpha / indent-blankline / fidget / trouble / dressing
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },   -- 大文件自动关掉 treesitter/LSP 等, 打开日志不卡
      quickfile = { enabled = true }, -- `nvim file` 时先渲染文件再加载插件
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },    -- 同时接管 vim.ui.select
      words = { enabled = true },     -- LSP 高亮光标下符号的所有引用
    },
    keys = {
      { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>f", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>f", function() Snacks.picker.grep_word() end, mode = "x", desc = "Grep selection" },
      { "<C-n>", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<space>c", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<space>j", function() Snacks.picker.jumps() end, desc = "Jumplist" },
      { "<space>p", function() Snacks.picker.resume() end, desc = "Resume last search" },
      { "<space>r", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<space>h", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<space>a", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<space>d", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<space>q", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      { "<space>l", function() Snacks.picker.loclist() end, desc = "Location list" },
      { "<space>n", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, mode = { "n", "t" }, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = { "n", "t" }, desc = "Prev reference" },
    },
  },
}
