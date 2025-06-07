local map = vim.keymap.set

MiniDeps.add({ source = "MagicDuck/grug-far.nvim" })

local grug_far = require("grug-far")

grug_far.setup({ transient = true })

map("n", "<leader>G", function() grug_far.open() end, { desc = "grug-far: search word" })
map("v", "<leader>.", function() grug_far.with_visual_selection() end, { desc = "grug-far: search" })
map("n", "<leader>.", function() grug_far.open({ prefills = { search = vim.fn.expand("<cword>") } }) end, {
	desc = "grug-far: search",
})
