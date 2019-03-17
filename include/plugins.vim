" Netrw {{{
"let g:netrw_liststyle = 1
let g:netrw_winsize = 25
let g:netrw_list_hide = '\.swp\($\|\t\),\.py[co]\($\|\t\),\.o\($\|\t\),\.bak\($\|\t\),\(^\|\s\s\)\zs\.\S\+'
let g:netrw_sort_sequence = '[\/]$,*,\.bak$,\.o$,\.info$,\.swp$,\.obj$'
let g:netrw_preview = 1
"let g:netrw_special_syntax = 1
let g:netrw_sort_options = 'i'

if isdirectory(expand('~/.vim'))
  let g:netrw_home = expand('~/.vim')
endif

let g:netrw_timefmt = "%Y-%m-%d %H:%M:%S"

"let g:netrw_banner=0
"let g:netrw_browse_split=4   " open in prior window
"let g:netrw_altv=1           " open splits to the right
"let g:netrw_liststyle=3      " tree view
"let g:netrw_list_hide=netrw_gitignore#Hide()

let s:ignore = ['.obj', '.so', '.a', '~', '.tmp', '.egg', '.class', '.jar']
let s:ignore += ['.tar.gz', '.zip', '.7z', '.bz2', '.rar', '.jpg', '.png']
let s:ignore += ['.chm', '.docx', '.xlsx', '.pptx', '.pdf', '.dll', '.pyd']

for s:extname in s:ignore
  let s:pattern = escape(s:extname, '.~') . '\($\|\t\),'
  " let g:netrw_list_hide = s:pattern . g:netrw_list_hide
endfor
" }}}

" Quickrun {{{
" see https://github.com/thinca/config/blob/master/dotfiles/dot.vim/vimrc#L3100
function! s:init_quickrun() abort
  for [key, c] in items({
        \   '<Leader>x': '>message',
        \   '<Leader>p': '-runner shell',
        \   '<Leader>"': '>variable:@"',
        \   '<Leader>w': '',
        \   '<Leader>W': '-append 1',
        \   '<Leader>ex': '-hook/eval/enable 1 >message',
        \   '<Leader>ep': '-hook/eval/enable 1 -runner shell',
        \   '<Leader>e"': '-hook/eval/enable 1 >variable:@"',
        \   '<Leader>ew': '-hook/eval/enable 1',
        \   '<Leader>eW': '-hook/eval/enable 1 -append 1',
        \ })
    execute 'nnoremap <silent>' key ':QuickRun' c '-mode n<CR>'
    execute 'vnoremap <silent>' key ':QuickRun' c '-mode v<CR>'
  endfor
  nmap <Leader>r <Plug>(quickrun-op)

  let g:quickrun_config = {
        \   '_': {
        \     'debug': 'ss',
        \     'input': '=%{b:input}', 'cmdopt': '%{b:cmdopt}', 'args': '%{b:args}',
        \     'runner': 'job',
        \   },
        \   'c/tcc': {'command': 'tcc', 'exec': '%c -run %o %s %a',
        \             'hook/eval/template': 'int main(int argc, char *argv[]){%s;}'},
        \   'cpp/gcc': {'cmdopt': '-std=c++0x'},
        \   'cpp/C': {'cmdopt': '-lstd=c++0x'},
        \   'clojure': {
        \     'command': 'clojure-1.4',
        \     'hook/eval/template': '(prn (do %s))'
        \   },
        \   'msil': {
        \     'command': 'ilasm',
        \   },
        \   'mysql': {
        \     'type': 'sql/mysql',
        \   },
        \   'powershell': {
        \     'type': 'ps1',
        \   },
        \   'lhaskell': {'command': 'runghc', 'tempfile': '%{tempname()}.lhs'},
        \   'nilscript': {'exec': 'ng.exe %s %a'},
        \   'ruby': {'hook/ruby_bundle/enable': 1},
        \   'ruby/rspec': {
        \     'command': 'rspec',
        \     'hook/ruby_bundle/enable': 1,
        \   },
        \   'xmodmap': {},
        \   'mxml': {'exec': ['amxmlc %s', 'adl %s:r-app.xml'],
        \            'output_encode': '&termencoding'},
        \ }

  let g:quickrun_config['csharp'] = {'type': 'cs'}

  let s:watchdogs_config = {
        \   'vim/watchdogs_checker': {
        \     'type': 'watchdogs_checker/vint',
        \   },
        \   'watchdogs_checker/_': {
        \     'outputter': 'loclist',
        \     'runner': 'job',
        \   },
        \   'watchdogs_checker/vint': {
        \     'command': 'vint',
        \     'exec': '%c %o %s',
        \   },
        \   'watchdogs_checker/rubocop': {
        \     'command': 'rubocop',
        \     'exec': '%c --format emacs %s',
        \     'outputter/quickfix/errorformat': '%f:%l:%c: %t: %m',
        \   },
        \   'watchdogs_checker/omnisharp': {
        \     'exec': 'call setloclist(0, OmniSharp#CodeCheck()) | lwindow',
        \     'runner': 'vimscript',
        \   },
        \   'watchdogs_checker/eslint': {
        \     'command': './node_modules/.bin/eslint',
        \     'exec': '%c --format unix %o %s',
        \     'outputter/loclist/errorformat': '%f:%l:%c: %m,%-G%.%#',
        \   },
        \ }

  let g:quickrun_config['csharp/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/omnisharp'
        \ }
  let g:quickrun_config['javascript/watchdogs_checker'] = {
        \   'type': 'watchdogs_checker/eslint'
        \ }
  " let s:watchdogs_config['ruby/watchdogs_checker'] =
  " \   {'type': 'watchdogs_checker/rubocop'}

  call extend(g:quickrun_config, s:watchdogs_config)

  if executable('C')
    let g:quickrun_config.c   = {'type': 'c/C'}
    let g:quickrun_config.cpp = {'type': 'cpp/C'}
  endif
  " if executable('tcc')
  "   let g:quickrun_config.c = {'type': 'c/tcc'}
  " endif
  let ruby_bundle_hook = {'kind': 'hook', 'name': 'ruby_bundle'}
  function! ruby_bundle_hook.on_normalized(session, context) abort
    if getcwd() !=# $HOME && isdirectory('.bundle')
      let a:session.config.exec =
            \   map(copy(a:session.config.exec), 's:bundle_exec(v:val)')
    endif
  endfunction
  function! s:bundle_exec(cmd) abort
    return substitute(a:cmd, '\ze%c', 'bundle exec ', '')
  endfunction
  "call quickrun#module#register(ruby_bundle_hook, 1)

  let rust_cargo_hook = {'kind': 'hook', 'name': 'rust_cargo'}
  function! rust_cargo_hook.on_normalized(session, context) abort
    if a:session.config.type ==# 'rust' &&
          \   findfile('Cargo.toml', '.;') !=# ''
      let a:session.config.exec = ['cargo run --quiet']
    endif
  endfunction
  "call quickrun#module#register(rust_cargo_hook, 1)

  map <Leader>or <Plug>(quickrun-op)
endfunction
call s:init_quickrun()

augroup vimrc-plugin-quickrun
  autocmd!
  autocmd BufReadPost,BufNewFile [Rr]akefile{,.rb}
        \ let b:quickrun_config = {'exec': 'rake -f %s'}
augroup END

function! s:complete_open_scratch(a, c, p) abort
  return sort(filter(keys(extend(copy(g:quickrun#default_config),
        \           g:quickrun_config)), 'v:val !~# "[*_/]" && v:val =~# "^".a:a'))
endfunction
function! s:open_scratch() abort
  let ft = input('type?', '', 'customlist,' . s:SIDP()
        \ . 'complete_open_scratch')
  if ft ==# ''
    return
  endif
  if 78 * 2 < winwidth(0)
    vnew
  else
    new
  endif
  let &l:filetype = ft
  call template#load('Scratch.' . ft)
endfunction
nnoremap <silent> <Leader><Leader>s :<C-u>call <SID>open_scratch()<CR>
" }}}

" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=0:
