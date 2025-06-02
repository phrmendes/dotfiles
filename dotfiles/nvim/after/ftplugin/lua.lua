local map = vim.keymap.set
local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

map("n", "<localleader>%", "<cmd>source %<cr>", { buffer = bufnr, desc = "lua: source file" })
map("n", "<localleader>.", ":.lua<cr>", { buffer = bufnr, desc = "lua: run line" })
map("x", "<localleader>.", ":lua<cr>", { buffer = bufnr, desc = "lua: run" })
map("n", "<leader>A", function() MiniTest.run() end, { buffer = bufnr, desc = "mini: run all tests" })
map("n", "<leader>G", function() MiniDoc.generate() end, { buffer = bufnr, desc = "mini: generate docs" })
map("n", "<leader>T", function() MiniTest.run_at_location() end, { buffer = bufnr, desc = "mini: run tests" })

map("n", "<localleader>dl", function() require("osv").launch({ port = 8086 }) end, {
	buffer = bufnr,
	desc = "Launch debugger",
})
