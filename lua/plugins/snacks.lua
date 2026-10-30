-- snacks.nvim 一个插件提供: 模糊搜索、侧边栏文件树、启动页、通知、缩进线、输入框、大文件优化、引用高亮
local function toggle_explorer()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if explorer then
    explorer:close()
  else
    Snacks.explorer()
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@return snacks.Config
    opts = function()
      -- LSP 符号类型用首字母 (Function -> F, Class -> C ...)
      local kinds = { Unknown = "? " }
      for name in pairs(vim.lsp.protocol.SymbolKind) do
        if type(name) == "string" then
          kinds[name] = name:sub(1, 1) .. " "
        end
      end

      return {
        bigfile = { enabled = true },   -- 大文件自动关掉 treesitter/LSP 等, 打开日志不卡
        quickfile = { enabled = true }, -- `nvim file` 时先渲染文件再加载插件
        dashboard = {
          enabled = true,
          preset = {
            keys = {
              { icon = "-", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = "-", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
              { icon = "-", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = "-", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = "-", key = "L", desc = "Lazy", action = ":Lazy" },
              { icon = "-", key = "q", desc = "Quit", action = ":qa" },
            },
          },
        },
        explorer = { enabled = true, replace_netrw = true },
        indent = { enabled = true },
        input = { enabled = true, icon = ">" },
        notifier = {
          enabled = true,
          icons = { error = "E ", warn = "W ", info = "I ", debug = "D ", trace = "T " },
        },
        picker = {
          enabled = true, -- 同时接管 vim.ui.select
          -- fancy diff 预览的 hunk 头写死了 Nerd Font 字符, 改用内置 diff 语法高亮
          previewers = { diff = { style = "syntax" } },
          -- picker 窗口里 <C-b> 默认是向上滚动; 在文件树里改成关闭, 和外面的开关键一致
          sources = {
            explorer = {
              win = {
                list = { keys = { ["<C-b>"] = "close" } },
                input = { keys = { ["<C-b>"] = { "close", mode = { "n", "i" } } } },
              },
            },
          },
          -- 文件图标来自 mini.icons; 下面是 snacks 自带的状态图标
          icons = {
            files = { dir = "+ ", dir_open = "- ", file = "  " }, -- 展开的目录不走 mini.icons
            keymaps = { nowait = "! " },
            undo = { saved = "* " },
            ui = { live = "~ ", selected = "* ", unselected = "  " },
            git = {
              commit = "", staged = "S", added = "A", deleted = "D", ignored = "!",
              modified = "M", renamed = "R", unmerged = "U", untracked = "?",
            },
            diagnostics = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " },
            lsp = { unavailable = "x ", enabled = "+ ", disabled = "- ", attached = "* " },
            kinds = kinds,
          },
        },
        words = { enabled = true }, -- LSP 高亮光标下符号的所有引用
      }
    end,
    keys = {
      -- 侧边栏文件树 (跟随当前文件, 显示 git 状态和诊断)
      { "<C-b>", toggle_explorer, desc = "Toggle file explorer" },
      { "<space>nn", toggle_explorer, desc = "Toggle file explorer" },
      { "<leader>n", function() Snacks.explorer.reveal() end, desc = "Reveal file in explorer" },
      -- 搜索
      { "<C-p>", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>f", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>f", function() Snacks.picker.grep_word() end, mode = "x", desc = "Grep selection" },
      { "<C-n>", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<space>c", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<space>j", function() Snacks.picker.jumps() end, desc = "Jumplist" },
      { "<space>p", function() Snacks.picker.resume() end, desc = "Resume last search" },
      { "<space>r", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<space>h", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>st", function() Snacks.picker.grep({ search = "\\b(TODO|FIXME|HACK|NOTE)\\b" }) end, desc = "Search TODOs" },
      -- 诊断 / 列表
      { "<space>a", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<space>d", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<space>q", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      { "<space>l", function() Snacks.picker.loclist() end, desc = "Location list" },
      { "<space>m", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      -- Git (审阅改动)
      { "<space>gst", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<space>glol", function() Snacks.picker.git_log() end, desc = "Git log" },
      -- LSP 引用跳转
      { "]]", function() Snacks.words.jump(vim.v.count1) end, mode = { "n", "t" }, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = { "n", "t" }, desc = "Prev reference" },
    },
  },
}
