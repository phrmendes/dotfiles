local gitsigns = require("gitsigns")

local map = vim.keymap.set

gitsigns.setup()

map("n", "[h", gitsigns.prev_hunk, { desc = "Git: Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Git: Next hunk" })
map("n", "<Leader>gb", gitsigns.toggle_current_line_blame, { desc = "Blame line" })
map("n", "<Leader>gd", gitsigns.diffthis, { desc = "Diff" })
