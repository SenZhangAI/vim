"----------------------------------------------------------------------
" packages begin
"----------------------------------------------------------------------
if !exists('g:bundle_group')
	let g:bundle_group = []
endif

silent! if plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))

"----------------------------------------------------------------------
" optional
"----------------------------------------------------------------------
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

call plug#end()
endif
