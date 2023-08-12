local bufremove = require("mini.bufremove")
local comment = require("mini.comment")
local hicursorword = require("mini.cursorword")
local indentscope = require("mini.indentscope")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local pairs = require("mini.pairs")
local splitjoin = require("mini.splitjoin")
local starter = require("mini.starter")
local statusline = require("mini.statusline")
local surround = require("mini.surround")
local tabline = require("mini.tabline")

bufremove.setup()
comment.setup()
hicursorword.setup()
indentscope.setup()
pairs.setup()
starter.setup()
tabline.setup()

jump2d.setup({ mappings = { start_jumping = "<localleader>j" } })
splitjoin.setup({ mappings = { toggle = "<localleader>t" } })
statusline.setup({ set_vim_settings = false })

surround.setup({
    mappings = {
        add = "<localleader>Sa",      -- add surrounding in normal and visual modes
        delete = "<localleader>Sd",   -- delete surrounding
        find = "<localleader>Sl",     -- find surrounding (to the right)
        find_left = "<localleader>Sh", -- find surrounding (to the left)
        highlight = "<localleader>SH", -- highlight surrounding
        replace = "<localleader>Sr",  -- replace surrounding
        update_n_lines = "<localleader>Sn", -- update `n_lines`
    },
})

move.setup({
    mappings = {
        -- visual mode
        left = "<S-h>",
        right = "<S-l>",
        down = "<S-j>",
        up = "<S-k>",
        -- normal mode
        line_left = "<S-h>",
        line_right = "<S-l>",
        line_down = "<S-j>",
        line_up = "<S-k>",
    },
})
