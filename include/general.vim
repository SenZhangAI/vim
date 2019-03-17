" Basic
set nocompatible

set winaltkeys=no
set backspace=eol,start,indent

" using clipboard cross application
set clipboard=unnamed

set updatetime=500

" Indent & Format {{{

"j: smart join multi-comment lines.
"n: smart indent numbered lists. "TODO I don't know what about it.
"B: When joining lines, don't insert a space between two multi-byte character
set formatoptions+=Bnj
au BufEnter * set fo-=c fo-=r fo-=o "don't insert comment automatically

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set autoindent
set cindent
set cinoptions=:0,l1,g0,t0,+0,cs,C1,(0,U1,m1,)50,*200

" for C-like programming where comments have explicit end character,
" if starting a new line in the middle of a comment automatically add comment character
autocmd FileType c,cpp,java setlocal formatoptions+=ro

" MAKEFILE and asm should use tab, not spaces
autocmd FileType make,asm setlocal noexpandtab shiftwidth=8 softtabstop=0

" autocmd FileType html,xhtml,xml setlocal tabstop=2 shiftwidth=2 softtabstop=2 autoindent

autocmd FileType vim setlocal shiftwidth=2 tabstop=2 softtabstop=2
" }}}

" Appearance {{{
set number
set relativenumber
set numberwidth=6
set ruler
set cursorline
set scrolloff=3
set wrap
set linebreak
set listchars=tab:^-,trail:-,eol:$,extends:>,precedes:<

" cursorline switched while focus is switched to another split window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
" set cursor to last position when reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set wildmenu
set wildmode=list:longest,full
" }}}

" Searching {{{
set hlsearch                          " search highlighting
set incsearch                         " incremental search
set ignorecase                        " ignore case when searching
set smartcase
" }}}

" File encoding {{{
if has('multi_byte')
  set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,gb18030,big5,euc-jp,latin1
  set fileencoding=utf-8
  set encoding=utf-8
  scriptencoding
endif
" }}}

" Filetype & syntax {{{
filetype on                           " enable filetype detection
filetype indent on                    " enable filetype-specific indenting
filetype plugin on                    " enable filetype-specific plugins
syntax enable
" }}}

" Saving & Undo {{{
autocmd BufWritePre * :%s/\s\+$//e " remove tailing whitespace

"set nobackup
"set nowritebackup
"set noswapfile

set swapfile
autocmd FocusLost * silent! wa "autosave
autocmd InsertLeave * silent! wa

if has('persistent_undo') " persistent_undo
  try
    set undofile
    set undodir=$HOME/.vim/.undo
  catch
  endtry
endif
set undolevels=100
set history=200
set viminfo^=% " Remember info about open buffers on close
set autoread " auto reload when changed by external
" }}}

" Complete config {{{
set complete+=k "TODO
set completeopt=menu,preview
" }}}

" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=0: