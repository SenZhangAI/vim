return {
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Surround editing
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Quick motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    opts = {},
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Easy align (kept from old config, still excellent)
  {
    "junegunn/vim-easy-align",
    keys = {
      { "\\=", "<Plug>(EasyAlign)", mode = { "n", "v" }, desc = "Easy align" },
    },
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
  },

  -- Color highlighter
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = {
        names = false,
      },
    },
  },

  -- Rainbow delimiters (treesitter-based)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Repeat support for plugin mappings
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- Case conversion (crs: snake_case, crm: MixedCase, etc.)
  { "tpope/vim-abolish", event = "VeryLazy" },

  -- Unimpaired bracket mappings
  { "tpope/vim-unimpaired", event = "VeryLazy" },
}
