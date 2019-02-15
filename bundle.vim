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

    Plug 'Chiel92/vim-autoformat'
    Plug 'junegunn/vim-easy-align'
    " Start interactive EasyAlign in visual mode(e.g. vip<hotkey>)
    vmap \= <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. <hotkey>ip)
    nmap \= <Plug>(EasyAlign)

    Plug 'easymotion/vim-easymotion'

    Plug 'Raimondi/delimitMate'
    let delimitMate_jump_expansion = 1
    let delimitMate_expand_space = 0
    let delimitMate_expand_cr = 2
    let delimitMate_expand_inside_quotes = 1
    let delimitMate_balance_matchpairs = 1
    au FileType c,cpp,java let b:delimitMate_insert_eol_marker = 2
    au FileType c,cpp,java let b:delimitMate_eol_marker = ";"
    imap <C-d> <Plug>delimitMateJumpMany

    Plug 'scrooloose/nerdcommenter'
    map <silent> <A-/> <Plug>NERDCommenterToggle

    Plug 'thinca/vim-quickrun'
endif

if index(g:bundle_group, 'git') >= 0
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    "Plug 'mhinz/vim-signify'
    nnoremap <SPACE>gd   :Gdiff<CR>
    nnoremap <SPACE>gst  :Gstatus<CR>
    nnoremap <SPACE>gbl  :Gblame<CR>
    nnoremap <SPACE>gwch :Git! whatchanged -p --abbrev-commit --pretty=medium<CR>
    nnoremap <SPACE>glol :Git log --graph --decorate --pretty=format:"\%Cred\%h\%Creset -\%C(auto)\%d\%Creset \%s \%Cgreen(\%cr) \%C(bold blue)<\%an>\%Creset"<CR>
endif

"----------------------------------------------------------------------
" package group - enhanced
"----------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0
endif

"----------------------------------------------------------------------
" package group - fantasic
"----------------------------------------------------------------------
if index(g:bundle_group, 'fantasic') >= 0
    Plug 'morhetz/gruvbox'
    Plug 'iCyMind/NeoSolarized'
    Plug 'jszakmeister/vim-togglecursor'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'

    Plug 'zhaocai/GoldenView.Vim'
    let g:goldenview__enable_default_mapping = 0

    Plug 'osyo-manga/vim-over'
    noremap <Leader>; :OverCommandLine<CR>

    let g:gutentags_modules = []
    if executable('ctags')
        let g:gutentags_modules += ['ctags']
    endif
    if executable('gtags-cscope') && executable('gtags')
        let g:gutentags_modules += ['gtags_cscope']
    endif
    if len(g:gutentags_modules) > 0
        "let g:gutentags_trace = 1 " debug for gutentags
        let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundles/*"]

        set tags=./.tags;,.tags
        Plug 'ludovicchabant/vim-gutentags'
        let g:gutentags_project_root = ['.git', '.idea', '.root', '.svn','.hg','.project']
        let g:gutentags_ctags_tagfile = '.tags'

        " let g:gutentags_modules = ['ctags', 'gtags_cscope']
        let g:gutentags_cache_dir = expand('~/.cache/tags')
        let g:gutentags_ctags_extra_args = []
        let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
        let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
        let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

        let g:gutentags_auto_add_gtags_cscope = 0

        " let g:gutentags_define_advanced_commands = 1

        if has('win32') || has('win16') || has('win64') || has('win95')
            let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
        endif

        let g:gutentags_plus_switch = 1
    endif

    if has('python') || has('python3')
        Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
        let g:Lf_ShortcutF = '<C-p>'
        let g:Lf_ShortcutB = '<m-n>'
        "noremap <C-m> :LeaderfMru<cr> "bug: this will alse make <CR> bind to this
        noremap <M-p> :LeaderfFunction!<cr>
        noremap <M-P> :LeaderfBufTag!<cr>
        noremap <M-N> :LeaderfBuffer<cr>
        noremap <M-m> :LeaderfTag<cr>

        let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
        let g:Lf_WorkingDirectoryMode = 'Ac'
        let g:Lf_WindowHeight = 0.30
        let g:Lf_CacheDirectory = expand('~/.vim/cache')
        let g:Lf_ShowRelativePath = 0
        let g:Lf_HideHelp = 1

        let g:Lf_WildIgnore = {
                    \ 'dir': ['.svn','.git','.hg'],
                    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
                    \ }

        let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
        let g:Lf_MruMaxFiles = 2048
        let g:Lf_StlColorscheme = 'powerline'
        let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
        let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}
        let g:Lf_NormalMap = {
                    \ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
                    \ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
                    \ "Mru": [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
                    \ "Tag": [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
                    \ "BufTag": [["<ESC>", ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
                    \ "Function": [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
                    \ }
    else
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'tacahiroy/ctrlp-funky'
        let g:ctrlp_map = ''
        noremap <C-p> :CtrlP<cr>
        noremap <C-m> :CtrlPMRUFiles<cr>
        noremap <M-p> :CtrlPFunky<cr>
        noremap <M-n> :CtrlPBuffer<cr>
    endif

    Plug 'vim-scripts/L9'
    Plug 'vim-scripts/FuzzyFinder'

    noremap <silent><tab>- :FufMruFile<cr>
    noremap <silent><tab>= :FufFile<cr>
    noremap <silent><tab>[ :FufBuffer<cr>
    noremap <silent><tab>] :FufBufferTag<cr>

    Plug 'dyng/ctrlsf.vim'

    Plug 'dkprice/vim-easygrep'
    map <silent> <Leader>vv <plug>EgMapGrepCurrentWord_v
    vmap <silent> <Leader>vv <plug>EgMapGrepSelection_v
    map <silent> <Leader>vr <plug>EgMapReplaceCurrentWord_r
    vmap <silent> <Leader>vr <plug>EgMapReplaceSelection_r
    map <silent> <S-F6> <plug>EgMapReplaceCurrentWord_r
    vmap <silent> <S-F6> <plug>EgMapReplaceSelection_r
endif

"----------------------------------------------------------------------
" language spec
"----------------------------------------------------------------------
if index(g:bundle_group, 'cpp') >= 0
    Plug 'nacitar/a.vim', { 'for': ['c', 'cpp'] }
    Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
endif

if index(g:bundle_group, 'golang') >= 0
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif

if index(g:bundle_group, 'markdown') >= 0
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
    Plug 'deoplete-plugins/deoplete-jedi'  "deoplete for python

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
    let NERDTreeChDirMode=2
    let NERDTreeMouseMode=2
    let g:nerdtree_tabs_focus_on_files=1
    let g:nerdtree_tabs_open_on_gui_startup=0
    " Appearance
    let g:NERDTreeWinSize = 35
    let g:NERDTreeMinimalUI = 1
    let g:NERDTreeDirArrows = 1
    noremap <leader>n :NERDTreeFind<cr>
    noremap <space>nn :NERDTreeToggle<cr>
    noremap <space>to :NERDTreeFocus<cr>
    noremap <space>tm :NERDTreeMirror<cr>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

if index(g:bundle_group, 'airline') >= 0
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
endif

if index(g:bundle_group, 'ale') >= 0
    Plug 'w0rp/ale'

    let g:airline#extensions#ale#enabled = 1
    let g:ale_linter_aliases = {
                \ 'vue': ['vue', 'javascript'],
                \}
    let g:ale_linters = {
                \ 'c': ['gcc', 'cppcheck'],
                \ 'cpp': ['gcc', 'cppcheck'],
                \ 'python': ['flake8', 'pylint'],
                \ 'lua': ['luac'],
                \ 'go': ['go build', 'gofmt'],
                \ 'java': ['javac'],
                \ 'javascript': ['eslint'],
                \ 'vue': ['eslint', 'vls'],
                \ }
    let g:ale_fixers= {
                \ 'python': ['autopep8', 'yapf'],
                \ }
    " Do not lint or fix minified files
    let g:ale_pattern_options = {
                \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
                \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
                \}
    " If you configure g:ale_pattern_options outside of vimrc, you need this.
    let g:ale_pattern_options_enabled = 1

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
    nmap <A-CR> <Plug>(ale_fix)
    "nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    "nmap <silent> <C-j> <Plug>(ale_next_wrap)
    "let g:ale_set_loclist = 0
    "let g:ale_set_quickfix = 1
    "let g:ale_open_list = 1
    " Set this if you want to.
    " This can be useful if you are combining ALE with
    " some other plugin which sets quickfix errors, etc.
    "let g:ale_keep_list_window_open = 1
endif

"----------------------------------------------------------------------
" package group - try: do some experiments
"----------------------------------------------------------------------
if index(g:bundle_group, 'try') >= 0
    Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-fuzzy.vim'
    Plug 'haya14busa/incsearch-easymotion.vim'
    Plug 'tpope/vim-obsession' " save current state of vim

    Plug 'svermeulen/vim-easyclip'
    inoremap <C-v> <plug>EasyClipInsertModePaste
endif

call plug#end()
endif
