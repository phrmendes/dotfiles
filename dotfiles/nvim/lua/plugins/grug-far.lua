local add, later = MiniDeps.add, MiniDeps.later
local map = vim.keymap.set

later(function()
	add({ source = "MagicDuck/grug-far.nvim" })

	local grug_far = require("grug-far")
	grug_far.setup({ transient = true })

	map("n", "<leader>G", function() grug_far.open() end, { desc = "grug-far" })
	map("v", "<leader>G", function() grug_far.with_visual_selection() end, { desc = "grug-far" })
end)
