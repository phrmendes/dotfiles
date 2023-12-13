local gitsigns = require("gitsigns")

local map = require("utils").map
local section = require("utils").section

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

section({
	key = "<leader>g",
	name = "git",
})

map({
	key = "]h",
	command = next_hunk,
	desc = "Next hunk",
}, {
	expr = true,
})

map({
	key = "[h",
	command = prev_hunk,
	desc = "Previous hunk",
}, {
	expr = true,
})

map({
	key = "<leader>gR",
	command = "<cmd>Telescope lazygit<cr>",
	desc = "Repos",
})

map({
	key = "<leader>gg",
	command = "<cmd>LazyGit<cr>",
	desc = "LazyGit",
})

map({
	key = "<leader>gb",
	command = gitsigns.toggle_current_line_blame,
	desc = "Blame line",
})

map({
	key = "<leader>gd",
	command = gitsigns.diffthis,
	desc = "Diff",
})

map({
	key = "<leader>gr",
	command = gitsigns.reset_hunk,
	desc = "Reset hunk",
})

map({
	key = "<leader>gs",
	command = gitsigns.stage_hunk,
	desc = "Stage hunk",
})
