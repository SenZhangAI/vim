"----------------------------------------------------------------------
" Vim 8 only plugin configuration (vim-plug)
" Neovim uses lua/config/ instead
"----------------------------------------------------------------------
let s:is_win = 0
if has('win32') || has('win64') || has('win95') || has('win16')
  let s:uname = 'windows'
  let s:is_win = 1
elseif has('unix')
  let s:uname = system("echo -n \"$(uname)\"")
  if !v:shell_error && s:uname ==? 'Linux'
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
" basic
"----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0
  Plug 'mhinz/vim-startify'
  noremap <space>ht :Startify<cr>

  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-commentary'

  Plug 'junegunn/vim-easy-align'
  vmap \= <Plug>(EasyAlign)
  nmap \= <Plug>(EasyAlign)

  Plug 'Raimondi/delimitMate'
  let delimitMate_jump_expansion = 1
  let delimitMate_expand_space = 0
  let delimitMate_expand_cr = 2
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_balance_matchpairs = 1
  au FileType c,cpp,java let b:delimitMate_insert_eol_marker = 2
  au FileType c,cpp,java let b:delimitMate_eol_marker = ';'
  imap <C-d> <Plug>delimitMateJumpMany

  Plug 'thinca/vim-quickrun'
  Plug 'SenZhangAI/vim-quickrun-neovim-job'
  Plug 'SenZhangAI/vim-quickrun-compileflags'

  let g:quickrun_config = {
        \ '_': {
        \   'outputter': 'buffer',
        \   'runner': has('job') ? 'job' : 'system',
        \   'cmdopt': '',
        \   'args': '',
        \   'tempfile': '%{tempname()}',
        \   'exec': '%c %o %s %a',
        \ },
        \ 'c': {
        \   'type':
        \     s:is_win && executable('cl') ? 'c/vc' :
        \     executable('clang')          ? 'c/clang' :
        \     executable('gcc')            ? 'c/gcc' : '',
        \ },
        \ 'c/clang': {
        \   'command': 'clang',
        \   'cmdopt': '-Wformat=0',
        \   'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
        \   'tempfile': '%{tempname()}.c',
        \   'hook/sweep/files': '%S:p:r',
        \ },
        \ 'c/gcc': {
        \   'command': 'gcc',
        \   'cmdopt': '-Wformat=0',
        \   'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
        \   'tempfile': '%{tempname()}.c',
        \   'hook/sweep/files': '%S:p:r',
        \ },
        \ 'cpp': {
        \   'type':
        \     s:is_win && executable('cl') ? 'cpp/vc' :
        \     executable('clang++')        ? 'cpp/clang++' :
        \     executable('g++')            ? 'cpp/g++' : '',
        \ },
        \ 'cpp/clang++': {
        \   'command': 'clang++',
        \   'cmdopt': '-std=c++17',
        \   'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
        \   'tempfile': '%{tempname()}.cpp',
        \   'hook/cd/directory': '%S:p:h',
        \   'hook/sweep/files': ['%S:p:r'],
        \   'hook/compileflags/cmdoptfile': 'compile_flags.txt',
        \ },
        \ 'cpp/g++': {
        \   'command': 'g++',
        \   'cmdopt': '-std=c++17',
        \   'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
        \   'tempfile': '%{tempname()}.cpp',
        \   'hook/cd/directory': '%S:p:h',
        \   'hook/sweep/files': ['%S:p:r'],
        \   'hook/compileflags/cmdoptfile': 'compile_flags.txt',
        \ },
        \}

  " FZF
  Plug 'junegunn/fzf', { 'dir': '~/.vim/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  let g:fzf_colors =
        \ { 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Normal'],
        \ 'hl':      ['fg', 'Comment'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'border':  ['fg', 'Ignore'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment'] }
  noremap <C-p> :Files<cr>
  noremap <C-n> :Buffers<cr>

  Plug 'dyng/ctrlsf.vim', {'on': ['CtrlSF', 'CtrlSFOpen', 'CtrlSFToggle']}

  Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

  Plug 'dhruvasagar/vim-open-url'
endif

"----------------------------------------------------------------------
" git
"----------------------------------------------------------------------
if index(g:bundle_group, 'git') >= 0
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  nnoremap <SPACE>gd   :Gdiffsplit<CR>
  nnoremap <SPACE>gst  :Git<CR>
  nnoremap <SPACE>gbl  :Git blame<CR>
  nnoremap <SPACE>glol :Git log --graph --decorate --pretty=format:"\%Cred\%h\%Creset -\%C(auto)\%d\%Creset \%s \%Cgreen(\%cr) \%C(bold blue)<\%an>\%Creset"<CR>
endif

"----------------------------------------------------------------------
" language spec
"----------------------------------------------------------------------
if index(g:bundle_group, 'cpp') >= 0
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
endif

if index(g:bundle_group, 'rust') >= 0
  Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
  let g:rustfmt_autosave = 1
endif

if index(g:bundle_group, 'python') >= 0
  " Python support via CoC (coc-pyright)
endif

if index(g:bundle_group, 'golang') >= 0
  " Go support via CoC (gopls)
endif

if index(g:bundle_group, 'markdown') >= 0
  Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  let g:tex_conceal = ''
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_no_extensions_in_markdown = 1
  let g:vim_markdown_strikethrough = 1
  let g:vim_markdown_new_list_item_indent = 2
  let g:vim_markdown_auto_insert_bullets = 1
endif

"----------------------------------------------------------------------
" themes
"----------------------------------------------------------------------
if index(g:bundle_group, 'themes') >= 0
  Plug 'morhetz/gruvbox'
endif

"----------------------------------------------------------------------
" rainbow
"----------------------------------------------------------------------
if index(g:bundle_group, 'rainbow') >= 0
  Plug 'luochen1990/rainbow'
  let g:rainbow_active = 1
  let g:rainbow_conf = {
        \   'guifgs': ['royalblue3', 'firebrick3', 'darkorange3', 'firebrick', 'seagreen3'],
        \   'ctermfgs': ['blue', 'red', 'brown', 'lightblue', 'darkred', 'darkcyan', 'darkmagenta'],
        \   'operators': '_,_',
        \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
        \   'separately': {
        \       '*': {},
        \       'css': 0,
        \       'sh': 0,
        \   }
        \}
endif

"----------------------------------------------------------------------
" nerdtree
"----------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
  Plug 'scrooloose/nerdtree'
  let NERDTreeChDirMode=2
  let NERDTreeMouseMode=2
  let g:nerdtree_tabs_focus_on_files=1
  let g:nerdtree_tabs_open_on_gui_startup=0
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
  noremap <leader>n :NERDTreeFind<cr>
  noremap <leader>m :NERDTreeClose<cr>
  noremap <space>nn :NERDTreeToggle<cr>
  noremap <space>to :NERDTreeFocus<cr>
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

"----------------------------------------------------------------------
" airline
"----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

"----------------------------------------------------------------------
" coc.nvim (Vim 8 LSP/completion)
"----------------------------------------------------------------------
if index(g:bundle_group, 'coc') >= 0
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'honza/vim-snippets'

  set hidden
  set nobackup
  set nowritebackup
  set shortmess+=c
  set signcolumn=yes

  " Tab completion
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  inoremap <silent><expr> <c-space> coc#refresh()
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

  " Diagnostics navigation
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " Go-to
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Hover docs
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Rename / Code action
  nmap <leader>rn <Plug>(coc-rename)
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>ac  <Plug>(coc-codeaction)
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Format
  xmap <leader>af <Plug>(coc-format-selected)
  nmap <leader>af <Plug>(coc-format-selected)
  command! -nargs=0 Format :call CocAction('format')

  " Function text objects
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  " CocList
  nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
  nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
  nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
  nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
  nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif

call plug#end()
endif
