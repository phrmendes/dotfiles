local map = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

map("n", "<localleader>dc", function() require("dap-python").test_class() end, {
	buffer = bufnr,
	desc = "Debug class",
})

map("n", "<localleader>df", function() require("dap-python").test_method() end, {
	buffer = bufnr,
	desc = "Debug function/method",
})

map("x", "<localleader>ds", function() require("dap-python").debug_selection() end, {
	buffer = bufnr,
	desc = "Debug selection",
})

map("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", { buffer = bufnr, desc = "Send to terminal" })
map("x", "<c-c><c-c>", "<Plug>SlimeRegionSend", { buffer = bufnr, desc = "Send to terminal" })
map("n", "<c-c><c-s>", "<Plug>SlimeSettings", { buffer = bufnr, desc = "Slime settings" })
