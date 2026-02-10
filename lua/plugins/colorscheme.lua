return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = { enabled = false },
      styles = {
        comments = { italic = false },
      },
    },
    config = function(_, opts)
      require("solarized").setup(opts)
      vim.o.background = "dark"
      vim.cmd.colorscheme("solarized")
    end,
  },
}
