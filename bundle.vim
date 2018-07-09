"----------------------------------------------------------------------
" system detection
"----------------------------------------------------------------------
if has('win32') || has('win64') || has('win95') || has('win16')
	let s:uname = 'windows'
elseif has('win32unix')
	let s:uname = 'cygwin'
elseif has('unix')
	let s:uname = system("echo -n \"$(uname)\"")
	if !v:shell_error && s:uname == "Linux"
		let s:uname = 'linux'
	elseif v:shell_error == 0 && match(s:uname, 'Darwin') >= 0
		let s:uname = 'darwin'
	else
		let s:uname = 'posix'
	endif
else
	let s:uname = 'posix'
endif


let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! s:path(path)
	let path = expand(s:home . '/' . a:path )
	return substitute(path, '\\', '/', 'g')
endfunc


"----------------------------------------------------------------------
" packages begin
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = []
endif

silent! if plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))

"----------------------------------------------------------------------
" package group - basic
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0
	Plug 'Raimondi/delimitMate'
endif

"----------------------------------------------------------------------
" package group - fantasic
"----------------------------------------------------------------------
if index(g:bundle_group, 'fantasic') >= 0
	Plug 'tpope/vim-surround'
	Plug 'zhaocai/GoldenView.Vim'
endif

"----------------------------------------------------------------------
" optional
"----------------------------------------------------------------------

" deoplete
if index(g:bundle_group, 'deoplete') >= 0
	if has('nvim')
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/deoplete.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif

	" Plug 'zchee/deoplete-clang'
	Plug 'zchee/deoplete-jedi'

	let g:deoplete#enable_at_startup = 1
	let g:deoplete#enable_smart_case = 1
	let g:deoplete#enable_refresh_always = 1

	inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<tab>"
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <expr><BS> deoplete#smart_close_popup()."\<bs>"
	inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

	let g:deoplete#sources = {}
	let g:deoplete#sources._ = ['buffer', 'dictionary']
	" let g:deoplete#sources.cpp = ['clang']
	let g:deoplete#sources.python = ['jedi']
	let g:deoplete#sources.cpp = ['omni']

	set shortmess+=c
	let g:echodoc#enable_at_startup = 1

	if exists('g:python_host_prog')
		let g:deoplete#sources#jedi#python_path = g:python_host_prog
	endif

	let g:deoplete#sources#jedi#enable_cache = 1
endif


if index(g:bundle_group, 'rainbow') >= 0
	Plug 'luochen1990/rainbow'
	let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
	let g:rainbow_conf = {
	\   'guifgs': ['royalblue3', 'firebrick3', 'darkorange3',  'firebrick','seagreen3'],
	\   'ctermfgs': ['blue', 'red', 'brown', 'lightblue', 'darkred',  'darkcyan', 'darkmagenta'],
	\   'operators': '_,_',
	\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\   'separately': {
	\       '*': {},
	\       'tex': {
	\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\       },
	\       'lisp': {
	\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\       },
	\       'vim': {
	\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold                     containedin=vimFuncBody'],
	\       },
	\       'html': {
	\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*       ))?)*\>/ end=#</\z1># fold'],
	\       },
	\       'css': 0,
	\   }
	\}
endif

if index(g:bundle_group, 'nerdtree') >= 0
	Plug 'scrooloose/nerdtree' ", {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	let NERDTreeChDirMode=2
	let NERDTreeMouseMode=2
	let g:nerdtree_tabs_focus_on_files=1
	let g:nerdtree_tabs_open_on_gui_startup=0
	" Appearance
	let g:NERDTreeMinimalUI = 1
	let g:NERDTreeDirArrows = 1
	"let g:NERDTreeFileExtensionHighlightFullName = 1
	"let g:NERDTreeExactMatchHighlightFullName = 1
	"let g:NERDTreePatternMatchHighlightFullName = 1
	noremap <leader>n :NERDTreeFind<cr>
	"noremap <space>to :NERDTreeFocus<cr>
	"noremap <space>tm :NERDTreeMirror<cr>
	"noremap <space>tt :NERDTreeToggle<cr>
endif

if index(g:bundle_group, 'airline') >= 0
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	let g:airline_theme='luna'
	" tabline
	let g:airline#extensions#tabline#enabled=1
	let g:airline#extensions#tabline#buffer_nr_show=1
	let g:airline#extensions#tabline#buffer_nr_format='%s:'
endif

if index(g:bundle_group, 'ale') >= 0
	Plug 'w0rp/ale'

	let g:airline#extensions#ale#enabled = 1
	let g:ale_linters = {
				\ 'c': ['gcc', 'cppcheck'],
				\ 'cpp': ['gcc', 'cppcheck'],
				\ 'python': ['flake8', 'pylint'],
				\ 'lua': ['luac'],
				\ 'go': ['go build', 'gofmt'],
				\ 'java': ['javac'],
				\ 'javascript': ['eslint'],
				\ }

	function s:lintcfg(name)
		let conf = s:path('tools/config/')
		let path1 = conf . a:name
		let path2 = expand('~/.vim/linter/'. a:name)
		if filereadable(path2)
			return path2
		endif
		return shellescape(filereadable(path2)? path2 : path1)
	endfunc

	let g:ale_python_flake8_options = '--conf='.s:lintcfg('flake8.conf')
	let g:ale_python_pylint_options = '--rcfile='.s:lintcfg('pylint.conf')
	let g:ale_python_pylint_options .= ' --disable=W'
	let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
	let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
	let g:ale_c_cppcheck_options = ''
	let g:ale_cpp_cppcheck_options = ''

	let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

	if executable('gcc') == 0 && executable('clang')
		let g:ale_linters.c += ['clang']
		let g:ale_linters.cpp += ['clang']
	endif
endif

call plug#end()
endif
