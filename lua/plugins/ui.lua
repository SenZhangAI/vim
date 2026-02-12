return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
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
      extensions = { "nvim-tree", "fugitive" },
    },
  },

  -- Buffer line (tab-like buffer display)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        numbers = "buffer_id",
        diagnostics = "nvim_lsp",
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<space>nn", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
      { "<leader>n", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
      { "<leader>m", "<cmd>NvimTreeClose<cr>", desc = "Close file tree" },
      { "<space>to", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
    },
    opts = {
      view = { width = 35 },
      renderer = {
        icons = { show = { git = true, folder = true, file = true } },
      },
      update_focused_file = { enable = true },
      actions = { open_file = { quit_on_open = false } },
    },
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
    },
  },

  -- Start screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Better UI for vim.ui.input (rename, etc.)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
    },
  },
}
