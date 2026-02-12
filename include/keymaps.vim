let mapleader=','
let g:mapleader=','

inoremap jk <ESC>`^

" move lines up and down using Alt+[jk] (aligns with VS Code Alt+Up/Down)
nmap <A-k> mz:m-2<cr>`z
map <A-j> mz:m+<cr>`z
vmap <A-k> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <A-j> :m'>+<cr>`<my`>mzgv`yo`z

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

nnoremap <leader>wa :wall<CR>

function! AutoEncoding()
  exec 'set fileencoding=utf-8'
  exec 'set ff=unix'
endfunc
nnoremap <leader>ae :call AutoEncoding()<CR>

function! MakeDir()
  exec '!mkdir -p %:h'
endfunc
nnoremap <leader>dir :call MakeDir()<CR>

" use arrow to shift buffer
noremap <left> :bp<CR>
noremap <right> :bn<CR>

" Allow using the repeat operator with a visual selection
vnoremap . :normal .<CR>

" Insert date
:nnoremap <C-R>d "=strftime("%F")<CR>P
:inoremap <C-R>d <C-R>=strftime("%F")<CR>
