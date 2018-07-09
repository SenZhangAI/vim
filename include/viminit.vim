" BASIC
set nocompatible

set winaltkeys=no
set backspace=eol,start,indent

set shiftwidth=4
set softtabstop=4
set noexpandtab
set tabstop=4
set cindent
set autoindent

set wildignore+=*.swp,*.bak,*.obj,*.o,*.exe,*.pyc,*.dll,*.so
set wildignore+=*.png,*.jpg,*.gif,*.ico
set wildignore+=*.swf,*.flv,*.mp3,*.mp4,*.avi,*.mkv,*.mpeg
set wildignore+=*.tar,*.gz,*.zip,*.rar,*.bz2
set wildignore+=*.git*,*.hg*,*.svn*
set wildignore+=*.DS_Store

" APPEARANCE
set number
set numberwidth=6
set ruler
set scrolloff=3
set wrap
set linebreak
set listchars=tab:^-,trail:·,eol:$,extends:>,precedes:<
" cursorline switched while focus is switched to another split window
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

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

"set autosave
set swapfile
autocmd FocusLost * silent! wa
autocmd InsertLeave * silent! wa

" remove tailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" set cursor to last position when reopen
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
