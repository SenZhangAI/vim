let mapleader=','
let g:mapleader=','

inoremap jk <ESC>

" move lines up and down using ctrl+[jk]
nmap <C-k> mz:m-2<cr>`z
map <C-j> mz:m+<cr>`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z

" auto format file
nnoremap <leader>af ggVG=

" select All
noremap <C-a> ggVG
inoremap <C-a> <ESC>ggVG

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" cancel searched highlight
nnoremap // :nohlsearch<CR>

" use arrow to shift buffer
noremap <left> :bp<CR>
noremap <right> :bn<CR>

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

function! NumberToggle()
  if(&rnu == 1)
    set nornu
  else
    set rnu
  endif
endfunc

nnoremap <F6> :call NumberToggle()<cr>
