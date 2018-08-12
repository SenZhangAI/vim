" BASIC
set nocompatible

set winaltkeys=no
set backspace=eol,start,indent

" using clipboard cross application
set clipboard+=unnamed

" INDENT
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

autocmd FileType html,xhtml,xml setlocal tabstop=2 shiftwidth=2 softtabstop=2 autoindent

" APPEARANCE
set number
set relativenumber
set numberwidth=6
set ruler
set cursorline
set scrolloff=3
set wrap
set linebreak
set listchars=tab:^-,trail:·,eol:$,extends:>,precedes:<
" cursorline switched while focus is switched to another split window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" color scheme
if has('termguicolors')
    set termguicolors
endif

if exists('$TMUX')
    set term=xterm-256color
endif

let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:solarized_transparent=1
colorscheme solarized
set background=dark

" menu
set wildmenu
set wildmode=longest:list,full

set hlsearch                          " search highlighting
set incsearch                         " incremental search
set ignorecase                        " ignore case when searching
set smartcase

" FORMAT
if has('multi_byte')
    set fileencodings=ucs-bom,utf-8,utf-16,gbk,gb18030,big5,euc-jp,latin1
    set fenc=utf-8
    set enc=utf-8
    scriptencoding
endif

" filetype & syntax setting
filetype on                           " enable filetype detection
filetype indent on                    " enable filetype-specific indenting
filetype plugin on                    " enable filetype-specific plugins
syntax enable

" SAVING
"set nobackup
"set nowritebackup
"set noswapfile

set history=200
set undolevels=100
set viminfo^=%                        " Remember info about open buffers on close

"set autosave
set swapfile
autocmd FocusLost * silent! wa
autocmd InsertLeave * silent! wa

" remove tailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" set cursor to last position when reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" make gitgutter faster
set updatetime=500
