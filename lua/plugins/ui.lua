-- 不依赖 Nerd Font: 图标统一由 mini.icons 的 ascii 风格提供, 各插件自带的图标改成 ASCII
return {
  -- 唯一的图标提供者; snacks / render-markdown 会优先用它
  {
    "nvim-mini/mini.icons",
    lazy = false,
    opts = { style = "ascii" },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Which-key: 很久不用 vim 时靠它回忆快捷键
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
      icons = {
        mappings = false,
        -- 不用 Nerd Font 时的按键名写法 (同 kickstart.nvim)
        keys = {
          Up = "<Up> ", Down = "<Down> ", Left = "<Left> ", Right = "<Right> ",
          C = "<C-...> ", M = "<M-...> ", D = "<D-...> ", S = "<S-...> ",
          CR = "<CR> ", Esc = "<Esc> ", NL = "<NL> ", BS = "<BS> ",
          Space = "<Space> ", Tab = "<Tab> ",
          ScrollWheelDown = "<ScrollWheelDown> ", ScrollWheelUp = "<ScrollWheelUp> ",
          F1 = "<F1>", F2 = "<F2>", F3 = "<F3>", F4 = "<F4>", F5 = "<F5>", F6 = "<F6>",
          F7 = "<F7>", F8 = "<F8>", F9 = "<F9>", F10 = "<F10>", F11 = "<F11>", F12 = "<F12>",
        },
      },
    },
  },
}
