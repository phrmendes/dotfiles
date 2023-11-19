local gitsigns = require("gitsigns")
local wk = require("which-key")

gitsigns.setup()

wk.register({
	name = "git",
	b = { gitsigns.toggle_current_line_blame, "Blame line" },
	d = { gitsigns.diffthis, "Diff" },
	g = { "<cmd>LazyGit<cr>", "LazyGit" },
}, { prefix = "<leader>g", mode = "n" })
