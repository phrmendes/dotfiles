require("octo").setup()

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
	mode = { "n", "v" },
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
	key = "<leader>ga",
	command = "<cmd>Gitsigns<cr>",
	desc = "Gitsigns",
})

map({
	key = "<leader>gb",
	command = function()
		gitsigns.blame_line({ full = true })
	end,
	desc = "Toggle blame line",
})

map({
	key = "<leader>gC",
	command = "<cmd>LazyGitFilter<cr>",
	desc = "Commits (repo)",
})

map({
	key = "<leader>gc",
	command = "<cmd>LazyGitFilterCurrentFile<cr>",
	desc = "Commits (file)",
})

map({
	key = "<leader>gd",
	command = gitsigns.diffthis,
	desc = "Diff (file)",
})

map({
	key = "<leader>gg",
	command = "<cmd>LazyGit<cr>",
	desc = "LazyGit",
})

map({
	key = "<leader>gl",
	command = "<cmd>Telescope lazygit<cr>",
	desc = "List repos",
})

map({
	key = "<leader>gp",
	command = gitsigns.preview_hunk,
	desc = "Preview hunk",
})

map({
	key = "<leader>gR",
	command = gitsigns.reset_buffer,
	desc = "Reset buffer",
})

map({
	key = "<leader>gr",
	command = gitsigns.reset_hunk,
	desc = "Reset hunk",
})

map({
	mode = "v",
	key = "<leader>gr",
	command = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Reset hunk",
})

map({
	key = "<leader>gS",
	command = gitsigns.stage_buffer,
	desc = "Stage buffer",
})

map({
	key = "<leader>gs",
	command = gitsigns.stage_hunk,
	desc = "Stage hunk",
})

map({
	mode = "v",
	key = "<leader>gs",
	command = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Stage hunk",
})

map({
	key = "<leader>gu",
	command = gitsigns.undo_stage_hunk,
	desc = "Undo stage hunk",
})
