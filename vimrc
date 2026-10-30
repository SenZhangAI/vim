so ~/.vim/vim/import.vim

if has('nvim')
  " Neovim: Lua 现代配置路径 (lazy.nvim + native LSP + treesitter)
  lua require('config')
else
  " Vim: 只用 include/ 共享基础设置, 不装插件 (临时改文件 / ssh 场景)
  set background=dark
  if has('termguicolors')
    set termguicolors
  endif
  silent! colorscheme NeoSolarized
endif
