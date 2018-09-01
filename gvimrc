set guioptions=aeh
set antialias

if has("gui_macvim")
    set guifont=Inconsolata\ for\ Powerline:h18
elseif has("gui_gtk")
    set guifont=Iosevka\ Regular\ 16
else
    set guifont=Monaco:h18
end
