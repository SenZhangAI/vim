-- Bootstrap lazy.nvim
local lazypath = vim.fn.expand("~/.vim/lazy/lazy.nvim")
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  root = vim.fn.expand("~/.vim/lazy"),
  defaults = { lazy = false },
  install = { colorscheme = { "solarized" } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
})
