let mapleader=','
let g:mapleader=','

inoremap jk <ESC>`^

" move lines up and down using Alt+[jk] (aligns with VS Code Alt+Up/Down)
nnoremap <A-k> mz:m-2<cr>`z
nnoremap <A-j> mz:m+<cr>`z
xnoremap <A-k> :m'<-2<cr>`>my`<mzgv`yo`z
xnoremap <A-j> :m'>+<cr>`<my`>mzgv`yo`z

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
  call mkdir(expand('%:p:h'), 'p')
endfunc
nnoremap <leader>dir :call MakeDir()<CR>

" use arrow to shift buffer
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Allow using the repeat operator with a visual selection
vnoremap . :normal .<CR>

" Insert date (普通模式不用 <C-R>d: 会让 <C-R> 重做等待 timeoutlen)
nnoremap <leader>id "=strftime("%F")<CR>P
inoremap <C-R>d <C-R>=strftime("%F")<CR>
