local ts_move = require("nvim-treesitter-textobjects.move")
local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
local modes = { "n", "x", "o" }

vim.keymap.set(modes, "]f", function() ts_move.goto_next_start("@function.outer", "textobjects") end, {
	desc = "Next function",
})

vim.keymap.set(modes, "[f", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, {
	desc = "Previous function",
})

vim.keymap.set(modes, "]c", function() ts_move.goto_next_start("@class.outer", "textobjects") end, {
	desc = "Next class",
})

vim.keymap.set(modes, "[c", function() ts_move.goto_previous_start("@class.outer", "textobjects") end, {
	desc = "Previous class",
})

vim.keymap.set(modes, ";", ts_repeat.repeat_last_move_next, { desc = "Repeat last move forward" })
vim.keymap.set(modes, ",", ts_repeat.repeat_last_move_previous, { desc = "Repeat last move backward" })
vim.keymap.set(modes, "f", ts_repeat.builtin_f_expr, { expr = true, desc = "Repeat f move forward" })
vim.keymap.set(modes, "F", ts_repeat.builtin_F_expr, { expr = true, desc = "Repeat F move backward" })
vim.keymap.set(modes, "t", ts_repeat.builtin_t_expr, { expr = true, desc = "Repeat t move forward" })
vim.keymap.set(modes, "T", ts_repeat.builtin_T_expr, { expr = true, desc = "Repeat T move backward" })
