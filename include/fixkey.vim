function! Terminal_MetaMode(mode)
  set ttimeout
  if $TMUX != ''
    set ttimeoutlen=30
  elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
    set ttimeoutlen=80
  endif
  if has('nvim') || has('gui_running')
    return
  endif
  function! s:metacode(mode, key)
    if a:mode == 0
      exec "set <M-".a:key.">=\e".a:key
    else
      exec "set <M-".a:key.">=\e]{0}".a:key."~"
    endif
  endfunc
  for i in range(10)
    call s:metacode(a:mode, nr2char(char2nr('0') + i))
  endfor
  for i in range(26)
    call s:metacode(a:mode, nr2char(char2nr('a') + i))
    call s:metacode(a:mode, nr2char(char2nr('A') + i))
  endfor
  if a:mode != 0
    for c in [',', '.', '/', ';', '[', ']', '{', '}']
      call s:metacode(a:mode, c)
    endfor
    for c in ['?', ':', '-', '_', '+', '=']
      call s:metacode(a:mode, c)
    endfor
  else
    for c in [',', '.', '/', ';', '{', '}']
      call s:metacode(a:mode, c)
    endfor
    for c in ['?', ':', '-', '_', '+', '=', "'"]
      call s:metacode(a:mode, c)
    endfor
  endif
endfunc

function! Terminal_KeyEscape(name, code)
  if has('nvim') || has('gui_running')
    return
  endif
  exec "set ".a:name."=\e".a:code
endfunc

command! -nargs=0 -bang VimMetaInit call Terminal_MetaMode(<bang>0)
command! -nargs=+ VimKeyEscape call Terminal_KeyEscape(<f-args>)

function! Terminal_FnInit(mode)
  if has('nvim') || has('gui_running')
    return
  endif
  if a:mode == 1
    VimKeyEscape <F1> OP
    VimKeyEscape <F2> OQ
    VimKeyEscape <F3> OR
    VimKeyEscape <F4> OS
    VimKeyEscape <S-F1> [1;2P
    VimKeyEscape <S-F2> [1;2Q
    VimKeyEscape <S-F3> [1;2R
    VimKeyEscape <S-F4> [1;2S
    VimKeyEscape <S-F5> [15;2~
    VimKeyEscape <S-F6> [17;2~
    VimKeyEscape <S-F7> [18;2~
    VimKeyEscape <S-F8> [19;2~
    VimKeyEscape <S-F9> [20;2~
    VimKeyEscape <S-F10> [21;2~
    VimKeyEscape <S-F11> [23;2~
    VimKeyEscape <S-F12> [24;2~
  endif
endfunc

call Terminal_MetaMode(0)
call Terminal_FnInit(1)


let s:iterm=
      \ exists('$ITERM_PROFILE') ||
      \ exists('$ITERM_SESSION_ID') ||
      \ exists('g:TerminusAssumeITerm') ||
      \ filereadable(expand('~/.vim/.assume-iterm'))
let s:iterm2=
      \ s:iterm &&
      \ exists('$TERM_PROGRAM_VERSION') &&
      \ match($TERM_PROGRAM_VERSION, '\v^[2-9]\.') == 0

if s:iterm2
  vmap "+y :w !pbcopy<CR><CR>
  nmap "+p :r !pbpaste<CR><CR>
end
