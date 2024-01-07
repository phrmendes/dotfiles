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

vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })

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
	key = "<leader>gc",
	command = "<cmd>Telescope git_branches<cr>",
	desc = "Checkout branch",
})

utils.map({
	key = "<leader>gd",
	command = gs.diffthis,
	desc = "Diff against index",
})

utils.map({
	key = "<leader>gD",
	command = function()
		gs.diffthis("~")
	end,
	desc = "Diff against last commit",
})

utils.map({
	key = "<leader>gs",
	command = "<cmd>Telescope git_status<cr>",
	desc = "Diff (repo)",
})

utils.map({
	key = "<leader>gt",
	command = gs.toggle_current_line_blame,
	desc = "Toggle blame line",
})

utils.map({
	key = "<leader>gbr",
	command = gs.reset_buffer,
	desc = "Reset",
})

utils.map({
	key = "<leader>gbs",
	command = gs.stage_buffer,
	desc = "Stage",
})

utils.map({
	key = "<leader>ghp",
	command = gs.preview_hunk,
	desc = "Preview",
})

utils.map({
	key = "<leader>ghr",
	command = gs.reset_hunk,
	desc = "Reset",
})

utils.map({
	mode = "v",
	key = "<leader>ghr",
	command = function()
		gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Reset",
})

utils.map({
	key = "<leader>ghs",
	command = gs.stage_hunk,
	desc = "Stage",
})

utils.map({
	mode = "v",
	key = "<leader>ghs",
	command = function()
		gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	desc = "Stage",
})

utils.map({
	key = "<leader>ghu",
	command = gs.undo_stage_hunk,
	desc = "Undo stage",
})
