local gitsigns = require("gitsigns")

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

vim.keymap.set("n", "]h", next_hunk, { desc = "Next hunk", expr = true })
vim.keymap.set("n", "[h", prev_hunk, { desc = "Previous hunk", expr = true })
vim.keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Blame line" })
vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope lazygit<cr>", { desc = "Repos" })
