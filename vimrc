so ~/.vim/vim/import.vim

if has('nvim')
  " Neovim: Lua 现代配置路径 (lazy.nvim + native LSP + treesitter)
  lua require('config')
else
  " Vim 8: VimScript + CoC 路径
  let g:bundle_group = ['basic', 'git', 'nerdtree', 'rainbow',
        \ 'airline', 'themes', 'coc',
        \ 'cpp', 'rust', 'python', 'golang', 'markdown']
  so ~/.vim/vim/bundle.vim

  if has('termguicolors')
    set termguicolors
  endif
  set background=dark
  colorscheme NeoSolarized

  let g:airline_theme='luna'
  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#tabline#buffer_nr_show=1
  let g:airline#extensions#tabline#buffer_nr_format='%s:'
endif
