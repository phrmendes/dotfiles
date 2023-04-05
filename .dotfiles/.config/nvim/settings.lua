require('indent_blankline').setup()

require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
}

require('lualine').setup {
    options = {
        icons_enabled = true,
    }
}

vim.o.background = 'dark'
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'noinsert,menuone,noselect'
vim.o.cursorline = true
vim.o.hidden = true
vim.o.inccommand = 'split'
vim.o.number = true
vim.o.relativenumber = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.title = true
vim.o.wildmenu = true
vim.o.expandtab = true
vim.o.ttimeoutlen = 0
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.undofile = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.scrolloff = 3