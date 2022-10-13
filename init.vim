"    ____      _ __        _
"   /  _/___  (_) /__   __(_)___ ___
"   / // __ \/ / __/ | / / / __ `__ \
" _/ // / / / / /__| |/ / / / / / / /
"/___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

"packages
call plug#begin()
    Plug 'asvetliakov/vim-easymotion'
    Plug 'tpope/vim-commentary'
    Plug 'frazrepo/vim-rainbow'
    Plug 'itchyny/lightline.vim'
    Plug 'preservim/nerdcommenter'
    Plug 'mileszs/ack.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf.vim'
    Plug 'psliwka/vim-smoothie'
    Plug 'preservim/nerdtree' 
call plug#end()

"vscode settings
if exists('g:vscode')
    "commentary function
    function! Comment()                                                                       
        if (mode() == "n" )
            execute "Commentary"
        else
            execute "'<,'>Commentary"
        endif
    endfunction

    function! s:split(...) abort
        let direction = a:1
        let file = a:2
        call VSCodeCall(direction == 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
        if file != ''
            call VSCodeExtensionNotify('open-file', expand(file), 'all')
        endif
    endfunction

    function! s:splitNew(...)
        let file = a:2
        call s:split(a:1, file == '' ? '__vscode_new__' : file)
    endfunction

    function! s:closeOtherEditors()
        call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
        call VSCodeNotify('workbench.action.closeOtherEditors')
    endfunction

    function! s:manageEditorSize(...)
        let count = a:1
        let to = a:2
        for i in range(1, count ? count : 1)
            call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
        endfor
    endfunction

    command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
    command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
    command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
    command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
    command! -bang Only if <q-bang> == '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

    nnoremap <silent> <C-w>s :call <SID>split('h')<CR>
    xnoremap <silent> <C-w>s :call <SID>split('h')<CR>

    nnoremap <silent> <C-w>v :call <SID>split('v')<CR>
    xnoremap <silent> <C-w>v :call <SID>split('v')<CR>

    nnoremap <silent> <C-w>n :call <SID>splitNew('h', '__vscode_new__')<CR>
    xnoremap <silent> <C-w>n :call <SID>splitNew('h', '__vscode_new__')<CR>


    nnoremap <silent> <C-w>= :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
    xnoremap <silent> <C-w>= :<C-u>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>

    nnoremap <silent> <C-w>> :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
    xnoremap <silent> <C-w>> :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
    nnoremap <silent> <C-w>+ :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
    xnoremap <silent> <C-w>+ :<C-u>call <SID>manageEditorSize(v:count, 'increase')<CR>
    nnoremap <silent> <C-w>< :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
    xnoremap <silent> <C-w>< :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
    nnoremap <silent> <C-w>- :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>
    xnoremap <silent> <C-w>- :<C-u>call <SID>manageEditorSize(v:count, 'decrease')<CR>

    " Better Navigation
    nnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    xnoremap <silent> <C-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    xnoremap <silent> <C-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
    nnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    xnoremap <silent> <C-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
    xnoremap <silent> <C-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

    " Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
    xnoremap <silent> <C-/> :call Comment()<CR>
    nnoremap <silent> <C-/> :call Comment()<CR>

    nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

    nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
    xnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>

    " Easymotion
    nmap s <Plug>(easymotion-s2)
else
    " Settings
    set nocompatible
    filetype off
    filetype plugin indent on
    set shell=/usr/bin/fish
    let g:rainbow_active = 1
    syntax enable
    set background=dark
    set nocompatible
    filetype on
    filetype plugin on
    filetype indent on
    set number
    set cursorline
    set shiftwidth=4
    set tabstop=4
    set expandtab
    set nobackup
    set scrolloff=10
    set incsearch
    set ignorecase
    set showmode
    set showmatch
    set hlsearch
    set history=1000
    set wildmenu
    set wildmode=list:longest
    set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
    set laststatus=2

    " Keybindings
    " Swap gj/gk with j/k.
    nnoremap <expr> j v:count ? 'j' : 'gj'
    nnoremap <expr> k v:count ? 'k' : 'gk'
    nnoremap gj j
    nnoremap gk k

    " Unhighlight by pusing escape keys twice.
    nnoremap <esc><esc> :nohlsearch<cr>

    " Yank a line with Y.
    nnoremap Y y$

    " Open buffers, files, and so on with fzf.
    nnoremap <leader>b :Buffers<cr>
    nnoremap <leader>c :History:<cr>
    nnoremap <leader>f :Files<cr>
    nnoremap <leader>g :GFiles<cr>
    nnoremap <leader>h :History<cr>
    nnoremap <leader>l :Lines<cr>
    nnoremap <leader>m :Maps<cr>
    nnoremap <leader>r :Ag<cr>
endif

