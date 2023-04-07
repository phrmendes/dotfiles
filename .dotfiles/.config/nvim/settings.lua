--------------------------------------------------------------------------------
-- _   ___     _____ __  __   ____  _____ _____ _____ ___ _   _  ____ ____    --
-- | \ | \ \   / /_ _|  \/  | / ___|| ____|_   _|_   _|_ _| \ | |/ ___/ ___|  --
-- |  \| |\ \ / / | || |\/| | \___ \|  _|   | |   | |  | ||  \| | |  _\___ \  --
-- | |\  | \ V /  | || |  | |  ___) | |___  | |   | |  | || |\  | |_| |___) | --
-- |_| \_|  \_/  |___|_|  |_| |____/|_____| |_|   |_| |___|_| \_|\____|____/  --
--------------------------------------------------------------------------------

-- leader key --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- theme --
vim.o.background = 'dark'

-- set highlight on search --
vim.o.hlsearch = true

-- make line numbers default --
vim.wo.number = true

-- enable mouse mode --
vim.o.mouse = 'a'

-- theme
vim.o.bg = 'dark'

-- sync clipboard between OS and neovim --
vim.o.clipboard = 'unnamedplus'

-- enable mouse mode --
vim.o.mouse = 'a'

-- enable break indent --
vim.o.breakindent = true

-- disable swap files
vim.o.swapfile = false

-- save undo history --
vim.o.undofile = true

-- case insensitive searching UNLESS /C or capital in search --
vim.o.ignorecase = true
vim.o.smartcase = true

-- keep signcolumn on by default --
vim.wo.signcolumn = 'yes'

-- decrease update time --
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- set completeopt to have a better completion experience --
vim.o.completeopt = 'noinsert,menuone,noselect'

-- config cursor line --
vim.o.cursorline = false

-- config smart indent --
vim.o.smartindent = true

-- highlight on yank --
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- keymaps for better default experience --
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- remap for dealing with word wrap --
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- treesitter settings --
require('nvim-treesitter.configs').setup {
  auto_install = false,
  highlight = { enable = true },
  indent = { 
    enable = true,
    additional_vim_regex_highlighting = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- automatically jump forward to textobj
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- indent blank lines settings --
require('indent_blankline').setup({
    opts = {
        char = '┊',
        show_trailing_blankline_indent = false,
    }
})

-- lualine settings --
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
