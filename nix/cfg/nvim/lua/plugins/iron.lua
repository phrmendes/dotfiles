local core = require("iron.core")
local pythonft = require("iron.fts.python")
local scalaft = require("iron.fts.scala")
local shft = require("iron.fts.sh")
local view = require("iron.view")

core.setup({
    config = {
        repl_open_cmd = view.split("25%"),
        repl_definition = {
            python = pythonft.ipython,
            scala = scalaft.scala,
            sh = shft.sh,
        },
    },
    keymaps = {
        clear = "<C-i>c",
        exit = "<C-i>q",
        interrupt = "<C-i>i",
        send_file = "<C-i>f",
        send_line = "<C-i>s",
        visual_send = "<C-i>s",
    },
    highlight = { italic = false },
    ignore_blank_lines = true,
})
