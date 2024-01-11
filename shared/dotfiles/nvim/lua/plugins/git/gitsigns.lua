local gs = require("gitsigns")
local utils = require("utils")

gs.setup()

local hunk = {
	prev = function()
		if vim.wo.diff then
			return "]h"
		end
		vim.schedule(function()
			gs.next_hunk()
		end)
		return "<Ignore>"
	end,
	next = function()
		if vim.wo.diff then
			return "[h"
		end
		vim.schedule(function()
			gs.prev_hunk()
		end)
		return "<Ignore>"
	end,
}

utils.map({
	key = "]h",
	cmd = hunk.next,
	desc = "Next hunk",
}, {
	expr = true,
})

utils.map({
	key = "[h",
	cmd = hunk.prev,
	desc = "Previous hunk",
}, {
	expr = true,
})

utils.map({
	key = "<leader>gc",
	cmd = "<cmd>Telescope git_branches<cr>",
	desc = "Checkout branch",
})

utils.map({
	key = "<leader>gd",
	cmd = gs.diffthis,
	desc = "Diff against index",
})

utils.map({
	key = "<leader>gD",
	cmd = function()
		gs.diffthis("~")
	end,
	desc = "Diff against last commit",
})

utils.map({
	key = "<leader>gs",
	cmd = "<cmd>Telescope git_status<cr>",
	desc = "Diff (repo)",
})

utils.map({
	key = "<leader>gt",
	cmd = gs.toggle_current_line_blame,
	desc = "Toggle blame line",
})

utils.map({
	key = "<leader>gbr",
	cmd = gs.reset_buffer,
	desc = "Reset",
})

utils.map({
	key = "<leader>gbs",
	cmd = gs.stage_buffer,
	desc = "Stage",
})

utils.map({
	key = "<leader>ghp",
	cmd = gs.preview_hunk,
	desc = "Preview",
})

utils.map({
	key = "<leader>ghr",
	cmd = gs.reset_hunk,
	desc = "Reset",
})

utils.map({
	mode = "v",
	key = "<leader>ghr",
	cmd = function()
		gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Reset",
})

utils.map({
	key = "<leader>ghs",
	cmd = gs.stage_hunk,
	desc = "Stage",
})

utils.map({
	mode = "v",
	key = "<leader>ghs",
	cmd = function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Stage",
})

utils.map({
	key = "<leader>ghu",
	cmd = gs.undo_stage_hunk,
	desc = "Undo stage",
})
