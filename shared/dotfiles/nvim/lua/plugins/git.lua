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

section({
	mode = { "n", "v" },
	key = "<leader>gb",
	name = "buffer",
})

section({
	mode = { "n", "v" },
	key = "<leader>gh",
	name = "hunk",
})

section({
	mode = { "n", "v" },
	key = "<leader>gc",
	name = "commits",
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
	key = "<leader>gb",
	command = function()
		gitsigns.blame_line({ full = true })
	end,
	desc = "Toggle blame line",
})

map({
	key = "<leader>gcr",
	command = "<cmd>LazyGitFilter<cr>",
	desc = "Repository",
})

map({
	key = "<leader>gcf",
	command = "<cmd>LazyGitFilterCurrentFile<cr>",
	desc = "File",
})

map({
	key = "<leader>gd",
	command = gitsigns.diffthis,
	desc = "Diff",
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
	key = "<leader>ghp",
	command = gitsigns.preview_hunk,
	desc = "Preview",
})

map({
	key = "<leader>gbr",
	command = gitsigns.reset_buffer,
	desc = "Reset",
})

map({
	key = "<leader>ghr",
	command = gitsigns.reset_hunk,
	desc = "Reset",
})

map({
	mode = "v",
	key = "<leader>ghr",
	command = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Reset",
})

map({
	key = "<leader>gbs",
	command = gitsigns.stage_buffer,
	desc = "Stage",
})

map({
	key = "<leader>ghs",
	command = gitsigns.stage_hunk,
	desc = "Stage",
})

map({
	mode = "v",
	key = "<leader>ghs",
	command = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Stage",
})

map({
	key = "<leader>ghu",
	command = gitsigns.undo_stage_hunk,
	desc = "Undo stage",
})
