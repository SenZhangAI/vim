return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>f", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<C-n>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<C-g>", "<cmd>Telescope tags<cr>", desc = "Tags" },
      { "<C-h>", "<cmd>Telescope current_buffer_tags<cr>", desc = "Buffer tags" },
      { "<space>c", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<space>e", "<cmd>Telescope find_files<cr>", desc = "Find files (space)" },
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
    end,
  },
}
