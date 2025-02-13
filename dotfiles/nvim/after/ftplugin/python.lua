local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<localleader>f", function() require("dap-python").test_method() end, {
	desc = "Python: debug function/method",
	buffer = bufnr,
})

vim.keymap.set("n", "<localleader>c", function() require("dap-python").test_class() end, {
	desc = "Python: debug class",
	buffer = bufnr,
})

vim.keymap.set("v", "<localleader>s", function() require("dap-python").debug_selection() end, {
	desc = "Python: debug selection",
	buffer = bufnr,
})
