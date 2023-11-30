local gitsigns = require("gitsigns")
local wk = require("which-key")

gitsigns.setup()

local prev_hunk = function()
	if vim.wo.diff then
		return "]h"
	end
	vim.schedule(function()
		gitsigns.next_hunk()
	end)
	return "<Ignore>"
end

local next_hunk = function()
	if vim.wo.diff then
		return "[h"
	end
	vim.schedule(function()
		gitsigns.prev_hunk()
	end)
	return "<Ignore>"
end

wk.register({
	h = { next_hunk, "Next hunk" },
}, { prefix = "]", mode = "n", expr = true })

wk.register({
	h = { prev_hunk, "Previous hunk" },
}, { prefix = "[", mode = "n", expr = true })

wk.register({
	name = "git",
	b = { gitsigns.toggle_current_line_blame, "Blame line" },
	d = { gitsigns.diffthis, "Diff" },
	g = { "<cmd>LazyGit<cr>", "LazyGit" },
	s = { "<cmd>Telescope lazygit<cr>", "Repos" },
}, { prefix = "<leader>g", mode = "n" })
