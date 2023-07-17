local core = require("iron.core")
local view = require("iron.view")
local scalaft = require("iron.fts.scala")
local shft = require("iron.fts.sh")

core.setup({
    config = {
        repl_open_cmd = view.split("25%"),
        repl_definition = {
            python = {command = {"ptipython", "-i", "-vi", "--dark-bg"}},
            scala = {scalaft.scala},
            sh = {shft.sh}
        }
    },
    keymaps = {
        clear = "<localleader>rc",
        exit = "<localleader>rq",
        send_file = "<localleader>rf",
        send_line = "<localleader>rl",
        visual_send = "<localleader>rs",
        interrupt = "<localleader>ri"
    },
    highlight = {italic = true},
    ignore_blank_lines = true
})