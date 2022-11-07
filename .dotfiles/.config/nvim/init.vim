""""""""""""""""""""""""""""""""""""""""
"     ____      _ __        _          "
"    /  _/___  (_) /__   __(_)___ ___  "
"    / // __ \/ / __/ | / / / __ `__ \ "
"  _/ // / / / / /__| |/ / / / / / / / "
" /___/_/ /_/_/\__(_)___/_/_/ /_/ /_/  "
""""""""""""""""""""""""""""""""""""""""

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
    Plug 'sheerun/vim-polyglot'
call plug#end()

"options
set background=dark
set clipboard=unnamedplus
set completeopt=noinsert,menuone,noselect
set cursorline
set hidden
set inccommand=split
set mouse=a
set number
set relativenumber
set splitbelow splitright
set title
set ttimeoutlen=0
set wildmenu
set expandtab
set shiftwidth=2
set tabstop=2
