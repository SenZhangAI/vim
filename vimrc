so ~/.vim/vim/import.vim

let g:bundle_group = ['basic']

call add(g:bundle_group, 'git')
call add(g:bundle_group, 'fantasic')
call add(g:bundle_group, 'cpp')
call add(g:bundle_group, 'rust')
"call add(g:bundle_group, 'python')
"call add(g:bundle_group, 'golang')
call add(g:bundle_group, 'haskell')
call add(g:bundle_group, 'markdown')
"call add(g:bundle_group, 'markdown-preview')
call add(g:bundle_group, 'themes')
call add(g:bundle_group, 'terminus')
call add(g:bundle_group, 'tags')
call add(g:bundle_group, 'coc')
"call add(g:bundle_group, 'deoplete')
call add(g:bundle_group, 'rainbow')
call add(g:bundle_group, 'nerdtree')
call add(g:bundle_group, 'tagbar')
call add(g:bundle_group, 'airline')
call add(g:bundle_group, 'ale')
"call add(g:bundle_group, 'try')

so ~/.vim/vim/bundle.vim

" color scheme
if has('termguicolors')
  set termguicolors
endif

if exists('$TMUX')
  set term=xterm-256color
  " hack to make vim work well in tmux
  let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
  let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
  " add the line below to .tmux.conf file
  " set-option -ga terminal-overrides ",xterm-256color:Tc"
endif

" default value is "normal", Setting this option to "high" or "low" does use the
" same Solarized palette but simply shifts some values up or down in order to
" expand or compress the tonal range displayed.
let g:neosolarized_contrast = "high"

" Special characters such as trailing whitespace, tabs, newlines, when displayed
" using ":set list" can be set to one of three levels depending on your needs.
" Default value is "normal". Provide "high" and "low" options.
let g:neosolarized_visibility = "low"

" I make vertSplitBar a transparent background color. If you like the origin solarized vertSplitBar
" style more, set this value to 0.
let g:neosolarized_vertSplitBgTrans = 1

" If you wish to enable/disable NeoSolarized from displaying bold, underlined or italicized
" typefaces, simply assign 1 or 0 to the appropriate variable. Default values:
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0

set background=dark
colorscheme NeoSolarized

if index(g:bundle_group, 'airline') >= 0
  let g:airline_theme='luna'
  " tabline
  let g:airline#extensions#tabline#enabled=1
  let g:airline#extensions#tabline#buffer_nr_show=1
  let g:airline#extensions#tabline#buffer_nr_format='%s:'
endif
