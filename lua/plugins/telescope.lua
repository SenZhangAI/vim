return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>f", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<C-n>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<space>c", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<space>j", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<space>p", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "%.o", "%.so", "%.a" },
        mappings = {
          i = {
            ["<Esc>"] = function(...)
              require("telescope.actions").close(...)
            end,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = false,
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
