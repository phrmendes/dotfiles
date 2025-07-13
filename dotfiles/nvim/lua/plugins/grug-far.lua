MiniDeps.later(function()
	MiniDeps.add({ source = "MagicDuck/grug-far.nvim" })

	local grug_far = require("grug-far")
	grug_far.setup({ transient = true })

	vim.keymap.set("n", "<leader>G", function() grug_far.open() end, { desc = "grug-far" })
	vim.keymap.set("v", "<leader>G", function() grug_far.with_visual_selection() end, { desc = "grug-far" })
end)
