let mapleader=','
let g:mapleader=','

inoremap jk <ESC>`^

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

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Insert date
:nnoremap <C-R>d "=strftime("%F")<CR>P
:inoremap <C-R>d <C-R>=strftime("%F")<CR>


function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx ==# 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo 'Location List is Empty.'
    return
  endif
  let winnr = winnr()
  exec(a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

" more toggle function see: <https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt>
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> yoq :call ToggleList("Quickfix List", 'c')<CR>
