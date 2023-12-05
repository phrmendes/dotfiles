local gitsigns = require("gitsigns")

local map = vim.keymap.set

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

map("n", "]h", next_hunk, { desc = "Next hunk", expr = true })
map("n", "[h", prev_hunk, { desc = "Previous hunk", expr = true })
map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Blame line" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
map("n", "<leader>gs", "<cmd>Telescope lazygit<cr>", { desc = "Repos" })
