local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

vim.keymap.set("n", "<localleader>dt", function() require("dap-go").debug_test() end, {
	buffer = bufnr,
	desc = "Debug test",
})

vim.keymap.set("n", "<localleader>dl", function() require("dap-go").debug_last() end, {
	buffer = bufnr,
	desc = "Debug last",
})
