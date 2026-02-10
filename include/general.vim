" Appearance && Behavior {{{
set number
set relativenumber
set numberwidth=6
if !has('nvim')
  set ruler
endif
set cursorline
set scrolloff=3
set cmdheight=2
set wrap
set linebreak
set listchars=tab:^-,trail:-,eol:$,extends:>,precedes:<

" cursorline switched while focus is switched to another split window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
" set cursor to last position when reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

if !has('nvim')
  set wildmenu
endif
set wildmode=list:longest,full

set updatetime=300

" using clipboard cross application
set clipboard=unnamed
if has('unnamedplus')
  set clipboard^=unnamedplus
endif

if !has('nvim')
  set backspace=eol,start,indent
endif

set winaltkeys=no
" }}}

" Indent & Format {{{
set formatoptions+=Bnj
set formatlistpat=^\\s*\\(\\d\\\|\\a\\)\\+[\\]:.)}\\t]\\s*
au BufEnter * set fo-=c fo-=r fo-=o

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

if !has('nvim')
  set autoindent
endif
set cindent
set cinoptions=:0,l1,g0,t0,+0,cs,C1,(0,U1,m1,)50,*200

autocmd FileType c,cpp,java setlocal formatoptions+=ro
autocmd FileType make,asm setlocal noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType vim,haskell,css,html,xml,js setlocal sw=2 ts=2 sts=2
" }}}

" Searching {{{
if !has('nvim')
  set hlsearch
  set incsearch
endif
set ignorecase
set smartcase
" }}}

" File encoding {{{
if !has('nvim') && has('multi_byte')
  set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,gb18030,big5,euc-jp,latin1
  set fileencoding=utf-8
  set encoding=utf-8
  scriptencoding
endif
" }}}

" Spelling Check {{{
setlocal spelllang=en_us,cjk
set nospell
" }}}

" Filetype & syntax {{{
if !has('nvim')
  filetype on
  filetype indent on
  filetype plugin on
  syntax enable
endif
" }}}

" Saving & Undo {{{
autocmd BufWritePre * :%s/\s\+$//e

set swapfile
set autowriteall
autocmd FocusLost * silent! wa
autocmd InsertLeave * silent! wa

if has('persistent_undo')
  try
    set undofile
    set undodir=$HOME/.vim/.undo
  catch
  endtry
endif
set undolevels=100
set history=200
if !has('nvim')
  set viminfo^=%
  set autoread
endif
" }}}

" Complete config {{{
set complete+=k
set completeopt=menu,preview
" }}}

" JSON comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=0:
