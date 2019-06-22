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

  Plug 'tpope/vim-unimpaired'

  Plug 'Chiel92/vim-autoformat'
  let g:formatdef_clangformat = "'clang-format -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=\"{BasedOnStyle: LLVM, AlignConsecutiveAssignments: true, AlignConsecutiveDeclarations: true, AlignTrailingComments: true, AllowShortBlocksOnASingleLine: true, FixNamespaceComments: true, BreakBeforeBraces: Linux, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, IndentPPDirectives: AfterHash, ColumnLimit: 0, '.(&expandtab ? 'UseTab: Never, IndentWidth: '.shiftwidth() : 'UseTab: Always').'}\"'"

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
  Plug 'jszakmeister/vim-togglecursor'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  Plug 'zhaocai/GoldenView.Vim'
  let g:goldenview__enable_default_mapping = 0

  Plug 'osyo-manga/vim-over'
  noremap <Leader>; :OverCommandLine<CR>


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

if index(g:bundle_group, 'python') >= 0
  Plug 'python-mode/python-mode', { 'branch': 'develop', 'for': 'python' }
  let g:pymode_python = 'python3'
endif

if index(g:bundle_group, 'rust') >= 0
  Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
  let g:rustfmt_autosave = 1
endif

if index(g:bundle_group, 'golang') >= 0
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'zchee/deoplete-go'

  " see https://github.com/fatih/vim-go-tutorial
  let g:go_fmt_command = "goimports"
  let g:go_autodetect_gopath = 1
  let g:go_list_type = "quickfix"

  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_generate_tags = 1

  " Open :GoDeclsDir with ctrl-g
  nmap <C-g> :GoDeclsDir<cr>
  imap <C-g> <esc>:<C-u>GoDeclsDir<cr>


  augroup go
    autocmd!

    " Show by default 4 spaces for a tab
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

    " :GoBuild and :GoTestCompile
    autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

    " :GoTest
    autocmd FileType go nmap <leader>t  <Plug>(go-test)

    " :GoRun
    autocmd FileType go nmap <leader>r  <Plug>(go-run)

    " :GoDoc
    autocmd FileType go nmap <Leader>d <Plug>(go-doc)

    " :GoCoverageToggle
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

    " :GoInfo
    autocmd FileType go nmap <Leader>i <Plug>(go-info)

    " :GoMetaLinter
    autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

    " :GoDef but opens in a vertical split
    autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
    " :GoDef but opens in a horizontal split
    autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

    " :GoAlternate  commands :A, :AV, :AS and :AT
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
  augroup END

  " build_go_files is a custom function that builds or compiles the test file.
  " It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
  function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
      call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
      call go#cmd#Build(0)
    endif
  endfunction
endif

if index(g:bundle_group, 'markdown') >= 0
  Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' } " use this to edit table
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  " LaTex math: support $x^2$, $$x^2$$ syntax
  let g:tex_conceal = ""
  let g:vim_markdown_math = 1
  " Highlight YAML frontmatter as used by jekyll
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_no_extensions_in_markdown = 1
  let g:vim_markdown_strikethrough = 1
  let g:vim_markdown_new_list_item_indent = 2
  "let g:vim_markdown_new_list_item_indent = 0
  let g:vim_markdown_auto_insert_bullets = 1
endif

if index(g:bundle_group, 'markdown-preview') >= 0
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
endif

if index(g:bundle_group, 'haskell') >= 0
  Plug 'neovimhaskell/haskell-vim', { 'for': ['haskell', 'cabal'] }
  let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
  let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
  let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
  let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
  let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
  let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
  let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
  let g:haskell_indent_if = 3
  let g:haskell_indent_case = 2
  let g:haskell_indent_let = 4
  let g:haskell_indent_where = 6
  let g:haskell_indent_before_where = 2
  let g:haskell_indent_after_bare_where = 2
  let g:haskell_indent_do = 3
  let g:haskell_indent_in = 1
  let g:haskell_indent_guard = 2
  let g:haskell_indent_case_alternative = 1
  let g:cabal_indent_section = 2

  "Plug 'alx741/vim-hindent', { 'for': ['haskell', 'cabal'] }
  "g:hindent_on_save = 1
endif

"----------------------------------------------------------------------
" optional
"----------------------------------------------------------------------
" Terminus enhances Vim's and Neovim's integration with the terminal in four ways, particularly when using tmux and iTerm or KDE Konsole, closing the gap between terminal and GUI Vim
if index(g:bundle_group, 'terminus') >= 0
  Plug 'wincent/terminus'
endif

if index(g:bundle_group, 'themes') >= 0
  Plug 'morhetz/gruvbox'
  Plug 'mhartington/oceanic-next'
endif

" tags
if index(g:bundle_group, 'tags') >= 0
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'skywind3000/gutentags_plus'
  let g:gutentags_modules = []
  if executable('ctags')
    let g:gutentags_modules += ['ctags']
  endif
  if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
  endif
  "let g:gutentags_trace = 1 " debug for gutentags
  let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundles/*"]

  set tags=./.tags;,.tags

  let g:gutentags_project_root = ['.git', '.idea', '.root', '.svn','.hg','.project']
  let g:gutentags_ctags_tagfile = '.tags'

  " let g:gutentags_modules = ['ctags', 'gtags_cscope']
  let g:gutentags_cache_dir = expand('~/.cache/tags')
  let g:gutentags_ctags_extra_args = []
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

  let g:gutentags_auto_add_gtags_cscope = 1

  " let g:gutentags_define_advanced_commands = 1

  if has('win32') || has('win16') || has('win64') || has('win95')
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
  endif

  let g:airline#extensions#gutentags#enabled = 1
  let g:gutentags_plus_switch = 1
endif

" coc
if index(g:bundle_group, 'coc') >= 0
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " use <tab> for trigger completion and navigate to the next complete item
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()

  " use <Tab> and <S-Tab> to navigate the completion list
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " use <CR> to confirm completion
  "inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " make <cr> select the first completion item and confirm the completion when no item has been selected
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
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
        \   'guis': [''],
        \   'cterms': [''],
        \   'operators': '_,_',
        \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
        \   'separately': {
        \       '*': {},
        \       'lisp': {
        \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
        \       },
        \       'haskell': {
        \           'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'],
        \       },
        \       'tex': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/(/ end=/)/ containedin=texDocZone', 'start=/\[/ end=/\]/ containedin=texDocZone'],
        \       },
        \       'vim': {
        \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
        \       },
        \       'xml': {
        \           'syn_name_prefix': 'xmlRainbow',
        \           'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
        \       },
        \       'xhtml': {
        \           'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
        \       },
        \       'html': {
        \           'parentheses': ['start=/\v\<((script|style|area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
        \       },
        \       'perl': {
        \           'syn_name_prefix': 'perlBlockFoldRainbow',
        \       },
        \       'php': {
        \           'syn_name_prefix': 'phpBlockRainbow',
        \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
        \       },
        \       'stylus': {
        \           'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
        \       },
        \       'css': 0,
        \       'sh': 0,
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
  "let g:NERDTreeWinSize = 35
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  noremap <leader>n :NERDTreeFind<cr>
  noremap <leader>m :NERDTreeClose<cr>
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
