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
        clear = "<C-r>c",
        exit = "<C-r>q",
        interrupt = "<C-r>i",
        send_file = "<C-r>f",
        send_line = "<C-r>s",
        visual_send = "<C-r>s",
    },
    highlight = { italic = false },
    ignore_blank_lines = true,
})
