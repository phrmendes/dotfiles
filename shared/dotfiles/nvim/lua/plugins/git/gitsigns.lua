local gitsigns = require("gitsigns")
local utils = require("utils")

gitsigns.setup()

local hunk = {
	prev = function()
		if vim.wo.diff then
			return "]h"
		end
		vim.schedule(function()
			gitsigns.next_hunk()
		end)
		return "<Ignore>"
	end,
	next = function()
		if vim.wo.diff then
			return "[h"
		end
		vim.schedule(function()
			gitsigns.prev_hunk()
		end)
		return "<Ignore>"
	end,
}

utils.map({
	key = "]h",
	command = hunk.next,
	desc = "Next hunk",
}, {
	expr = true,
})

utils.map({
	key = "[h",
	command = hunk.prev,
	desc = "Previous hunk",
}, {
	expr = true,
})

utils.map({
	key = "<leader>gb",
	command = function()
		gitsigns.blame_line({ full = true })
	end,
	desc = "Toggle blame line",
})

utils.map({
	key = "<leader>gd",
	command = gitsigns.diffthis,
	desc = "Diff",
})

utils.map({
	key = "<leader>gB",
	command = "<cmd>Telescope git_branches<cr>",
	desc = "Branches",
})

utils.map({
	key = "<leader>gD",
	command = "<cmd>Telescope git_status<cr>",
	desc = "Diff (repo)",
})

utils.map({
	key = "<leader>ghp",
	command = gitsigns.preview_hunk,
	desc = "Preview",
})

utils.map({
	key = "<leader>ghr",
	command = gitsigns.reset_hunk,
	desc = "Reset",
})

utils.map({
	mode = "v",
	key = "<leader>ghr",
	command = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Reset",
})

utils.map({
	key = "<leader>ghs",
	command = gitsigns.stage_hunk,
	desc = "Stage",
})

utils.map({
	mode = "v",
	key = "<leader>ghs",
	command = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Stage",
})

utils.map({
	key = "<leader>ghu",
	command = gitsigns.undo_stage_hunk,
	desc = "Undo stage",
})

utils.map({
	key = "<leader>gbr",
	command = gitsigns.reset_buffer,
	desc = "Reset",
})

utils.map({
	key = "<leader>gbs",
	command = gitsigns.stage_buffer,
	desc = "Stage",
})
