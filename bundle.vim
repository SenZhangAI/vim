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
    Plug 'mhinz/vim-startify'
    noremap <space>ht :Startify<cr>
    noremap <space>hy :tabnew<cr>:Startify<cr>

    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    Plug 'Raimondi/delimitMate'
    let delimitMate_jump_expansion = 1
    let delimitMate_expand_space = 0
    let delimitMate_expand_cr = 2
    let delimitMate_expand_inside_quotes = 1
    let delimitMate_balance_matchpairs = 1
    au FileType c,cpp,java let b:delimitMate_insert_eol_marker = 2
    au FileType c,cpp,java let b:delimitMate_eol_marker = ";"

    Plug 'scrooloose/nerdcommenter'
    map <silent> \\ <Plug>NERDCommenterToggle

    if has('python') || has('python3')
        Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
        let g:Lf_ShortcutF = '<c-p>'
        let g:Lf_ShortcutB = '<m-n>'
        noremap <c-n> :LeaderfMru<cr>
        noremap <m-p> :LeaderfFunction!<cr>
        noremap <m-P> :LeaderfBufTag!<cr>
        noremap <m-n> :LeaderfBuffer<cr>
        noremap <m-m> :LeaderfTag<cr>
        let g:Lf_MruMaxFiles = 2048
        let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
    else
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'tacahiroy/ctrlp-funky'
        let g:ctrlp_map = ''
        noremap <c-p> :CtrlP<cr>
        noremap <c-n> :CtrlPMRUFiles<cr>
        noremap <m-p> :CtrlPFunky<cr>
        noremap <m-n> :CtrlPBuffer<cr>
    endif
endif

"----------------------------------------------------------------------
" package group - enhanced
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0
endif

"----------------------------------------------------------------------
" package group - try
"----------------------------------------------------------------------
if index(g:bundle_group, 'try') >= 0
    Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-fuzzy.vim'
    Plug 'haya14busa/incsearch-easymotion.vim'
    Plug 'tpope/vim-obsession' " save current state of vim

    Plug 'svermeulen/vim-easyclip'
    inoremap <c-v> <plug>EasyClipInsertModePaste
endif

"----------------------------------------------------------------------
" package group - fantasic
"----------------------------------------------------------------------
if index(g:bundle_group, 'fantasic') >= 0
    Plug 'morhetz/gruvbox'
    Plug 'jszakmeister/vim-togglecursor'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'zhaocai/GoldenView.Vim'
    Plug 'osyo-manga/vim-over'
    noremap <Leader>; :OverCommandLine<CR>
endif

"----------------------------------------------------------------------
" optional
"----------------------------------------------------------------------
" Terminus enhances Vim's and Neovim's integration with the terminal in four ways, particularly when using tmux and iTerm or KDE Konsole, closing the gap between terminal and GUI Vim
if index(g:bundle_group, 'terminus') >= 0
    Plug 'wincent/terminus'
endif

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
    noremap <space>to :NERDTreeFocus<cr>
    noremap <space>tm :NERDTreeMirror<cr>
    noremap <space>tt :NERDTreeToggle<cr>
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

if index(g:bundle_group, 'markdown') >= 0
    Plug 'junegunn/vim-easy-align' " better than tabular
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' } " use this to edit table
    " LaTex math: support $x^2$, $$x^2$$ syntax
    let g:tex_conceal = ""
    let g:vim_markdown_math=1
    " Highlight YAML frontmatter as used by jekyll
    let g:vim_markdown_frontmatter=1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_no_extensions_in_markdown = 1
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
    let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++17'
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
