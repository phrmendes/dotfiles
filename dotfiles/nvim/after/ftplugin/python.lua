local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

vim.keymap.set("n", "<localleader>dc", function() require("dap-python").test_class() end, {
	buffer = bufnr,
	desc = "Debug class",
})

vim.keymap.set("n", "<localleader>df", function() require("dap-python").test_method() end, {
	buffer = bufnr,
	desc = "Debug function/method",
})

vim.keymap.set("x", "<localleader>ds", function() require("dap-python").debug_selection() end, {
	buffer = bufnr,
	desc = "Debug selection",
})

vim.keymap.set("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", { buffer = bufnr, desc = "Send to terminal" })
vim.keymap.set("x", "<c-c><c-c>", "<Plug>SlimeRegionSend", { buffer = bufnr, desc = "Send to terminal" })
vim.keymap.set("n", "<c-c><c-s>", "<Plug>SlimeSettings", { buffer = bufnr, desc = "Slime settings" })
