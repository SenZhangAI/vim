return {
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    event = "InsertEnter",
    opts = {
      disable_auto_comment = true,
      accept_keymap = "<C-]>",
      dismiss_keymap = "<C-[>",
      debounce_ms = 300,
    },
    config = function(_, opts)
      require("tabnine").setup(opts)
    end,
  },
}
