set mouse=a

if exists("g:GuiLoaded")
    GuiFont JetBrainsMono Nerd Font:h12
    GuiPopupmenu 0
    GuiScrollBar 0
    GuiTabline 0
endif

nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv


