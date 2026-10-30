" 所有 autocmd 归入同一 group, 重复 source vimrc 时不会叠加
augroup vimrc_general
  autocmd!
augroup END

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
autocmd vimrc_general WinEnter * setlocal cursorline
autocmd vimrc_general WinLeave * setlocal nocursorline
" set cursor to last position when reopen (skip git commit messages)
autocmd vimrc_general BufReadPost *
      \ if &ft !~# 'commit' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

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

" }}}

" Indent & Format {{{
set formatoptions+=Bnj
set formatlistpat=^\\s*\\(\\d\\\|\\a\\)\\+[\\]:.)}\\t]\\s*

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

if !has('nvim')
  set autoindent
endif
set cindent
set cinoptions=:0,l1,g0,t0,+0,cs,C1,(0,U1,m1,)50,*200

autocmd vimrc_general FileType make,asm setlocal noexpandtab shiftwidth=8 softtabstop=0
autocmd vimrc_general FileType vim,lua,haskell,css,html,xml,javascript,json,yaml setlocal sw=2 ts=2 sts=2
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
set spelllang=en_us,cjk
set nospell
" }}}

" Filetype & syntax {{{
" nvim 默认在 init 之后才开 filetype; 这里显式提前, 下面的 FileType autocmd 才能排在 ftplugin 之后
filetype plugin indent on
if !has('nvim')
  syntax enable
endif

" ftplugin 会改写 formatoptions; 本 FileType autocmd 注册在 ftplugin 之后, 所以最终生效.
" (旧写法用 BufEnter 全局清除, 把下面 c/cpp/java 的 +=ro 也一起清掉了)
autocmd vimrc_general FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd vimrc_general FileType c,cpp,java setlocal formatoptions+=ro
" }}}

" Saving & Undo {{{
" 去行尾空白: 保留光标/视图和搜索历史; markdown 行尾两空格是硬换行, diff/patch 不能改
function! s:StripTrailingWhitespace() abort
  if &binary || &ft =~# '^\(markdown\|diff\|gitsendemail\)$' || !&modifiable
    return
  endif
  let l:view = winsaveview()
  keeppatterns silent! %s/\s\+$//e
  call winrestview(l:view)
endfunction
autocmd vimrc_general BufWritePre * call s:StripTrailingWhitespace()

set swapfile
" 文件常被 Claude 等外部程序修改: 不自动保存 (会把旧 buffer 写回覆盖别人的改动),
" 而是在回到编辑器/切 buffer/空闲时检查磁盘, 未修改的 buffer 自动重新载入
set autoread
autocmd vimrc_general FocusGained,BufEnter,CursorHold *
      \ if mode() !=# 'c' && getcmdwintype() ==# '' | silent! checktime | endif

" Neovim 的 undo 文件格式和 Vim 不兼容 (混用同一目录会报 E824),
" 所以只给 Vim 指定 ~/.vim/.undo, Neovim 用默认的 stdpath('state')/undo
set undofile
if !has('nvim')
  set undodir=$HOME/.vim/.undo
  set history=1000
endif
set undolevels=1000
if !has('nvim')
  set viminfo^=%
endif
" }}}

" Complete config (vim only; nvim-cmp overrides in Lua) {{{
if !has('nvim')
  set complete+=k
  set completeopt=menu,preview
endif
" }}}

" JSON comment highlighting (vim regex 语法; nvim 下 treesitter 接管高亮)
autocmd vimrc_general FileType json syntax match Comment +\/\/.\+$+

" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=0:
