" Leader keys
let mapleader = " "
let maplocalleader = ","

" Syntax
syntax enable

" Filetype plugin
filetype plugin on

" Line numbers
set relativenumber
set number

" Tabs and indentation
set autoindent
set breakindent
set expandtab
set linebreak
set shiftwidth=4
set showtabline=1
set tabstop=4
set wrap

" Search settings
set ignorecase
set smartcase
set hlsearch

" Cursor line
set cursorline

" Appearance
set background=dark
set signcolumn=yes
set termguicolors

" Backspace
set backspace=indent,eol,start

" Split windows
set splitright
set splitbelow

" Disable backup files
set nobackup
set nowritebackup
set noswapfile

" Save undo history
set undofile

" Decrease update time
set updatetime=200
set timeout
set timeoutlen=300

" Better completion experience
set completeopt=menuone,noselect

" Default terminal
set shell=zsh

" Preview substitutions live
set inccommand=split

" Conceal
set conceallevel=2

" Fold
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable

" Clipboard (set if available)
if has('clipboard')
    set clipboard=unnamedplus
endif

" Treat '-' as part of a word
set iskeyword+=-

" Disable native show mode message
set noshowmode

" Spell
set nospell

" Confirm before operations in files with unsaved changes
set confirm

" Highlight yanked text
augroup highlight-yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" Center cursor after half-page jumps
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Better default keys for navigation and search
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> N "nN"[v:searchforward()]."zv"
onoremap <expr> N "nN"[v:searchforward()]
xnoremap <expr> N "nN"[v:searchforward()]
nnoremap <expr> n "Nn"[v:searchforward()]."zv"
onoremap <expr> n "Nn"[v:searchforward()]
xnoremap <expr> n "Nn"[v:searchforward()]

" Leader keys
nnoremap <leader>- :split<CR>
nnoremap <leader>\ :vsplit<CR>
nnoremap <leader>W :wall!<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :silent w!<CR>
nnoremap <leader>x :copen<CR>
nnoremap <leader>Q :lua vim.diagnostic.setloclist()<CR>

" Buffer keys
nnoremap <leader>bG :blast<CR>
nnoremap <leader>bg :bfirst<CR>
nnoremap <leader>bk :wall! \| %bdelete \| edit# \| bdelete#<CR>

" Tab keys
nnoremap [<tab> :tabprevious<CR>
nnoremap ]<tab> :tabnext<CR>
nnoremap <leader><tab>G :tablast<CR>
nnoremap <leader><tab>q :tabclose<CR>
nnoremap <leader><tab>g :tabfirst<CR>
nnoremap <leader><tab>k :tabonly<CR>
nnoremap <leader><tab>n :tabnew<CR>
nnoremap <leader><tab>e :tabedit %<CR>

" Window navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
