"function for import scripts
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
command! -nargs=1 Import exec 'so '.s:home.'/'.'<args>'
" add to runtimepath
exec 'set rtp+='.s:home
