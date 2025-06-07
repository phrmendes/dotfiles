local map = vim.keymap.set
local cmd = vim.api.nvim_buf_create_user_command
local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

map("n", "<localleader>%", "<cmd>source %<cr>", { buffer = bufnr, desc = "lua: source file" })
map("n", "<localleader>.", ":.lua<cr>", { buffer = bufnr, desc = "lua: run line" })
map("x", "<localleader>.", ":lua<cr>", { buffer = bufnr, desc = "lua: run" })
map("n", "<localleader>dl", function() require("osv").launch({ port = 8086 }) end, {
	buffer = bufnr,
	desc = "Launch debugger",
})

cmd(bufnr, "RunAllTests", function() MiniTest.run() end, {
	nargs = 0,
	desc = "mini: run all tests",
})

cmd(bufnr, "RunTest", function() MiniTest.run_at_location() end, {
	nargs = 0,
	desc = "mini: run test",
})

cmd(bufnr, "GenerateDocs", function() MiniDoc.generate() end, {
	nargs = 0,
	desc = "mini: generate docs",
})
