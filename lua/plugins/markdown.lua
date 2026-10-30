return {
  -- 在 buffer 内渲染标题/表格/代码块/复选框, 光标所在行显示原文
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle markdown render" },
    },
    -- 默认图标是 Nerd Font 字符, 改成 ASCII
    opts = {
      heading = {
        sign = false,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
      },
      code = { sign = false, language_icon = false },
      checkbox = {
        unchecked = { icon = "[ ] " },
        checked = { icon = "[x] " },
        custom = { todo = { rendered = "[-] " } },
      },
      -- 链接/图片/邮箱/脚注前的图标: 关掉
      link = { enabled = false },
      -- GitHub 的 5 种 callout; 其余 Obsidian 专用类型保持默认
      callout = {
        note = { rendered = "Note" },
        tip = { rendered = "Tip" },
        important = { rendered = "Important" },
        warning = { rendered = "Warning" },
        caution = { rendered = "Caution" },
      },
    },
  },
}
