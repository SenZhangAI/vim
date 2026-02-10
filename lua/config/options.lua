local opt = vim.opt

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cmdheight = 2
opt.inccommand = "split" -- live substitution preview (replaces vim-over)
opt.shortmess:append("c")

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- No backup (LSP servers can have issues with backup files)
opt.backup = false
opt.writebackup = false

-- Disable netrw (nvim-tree replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
