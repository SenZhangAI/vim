let mapleader=','
let g:mapleader=','

inoremap jk <ESC>

" move lines up and down using ctrl+[jk]
nmap <C-k> mz:m-2<cr>`z
map <C-j> mz:m+<cr>`z
vmap <C-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <C-j> :m'>+<cr>`<my`>mzgv`yo`z

" auto format file
nnoremap <leader>af :Autoformat<CR>

" force save when normal user is forbiddened
noremap <leader>wf :w !sudo tee > /dev/null %<CR><ESC>

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

nnoremap <leader>wa :wall<CR>


function! AutoEncoding()
  exec "set fileencoding=utf-8"
  exec "set ff=unix"
endfunc

nnoremap <leader>ae :call AutoEncoding()<CR>

" use arrow to shift buffer
noremap <left> :bp<CR>
noremap <right> :bn<CR>

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Insert date
:nnoremap <C-R>d "=strftime("%F")<CR>P
:inoremap <C-R>d <C-R>=strftime("%F")<CR>
