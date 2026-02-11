local bufnr = vim.api.nvim_get_current_buf()

require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

vim.keymap.set("n", "<localleader>%", "<cmd>source %<cr>", { buffer = bufnr, desc = "lua: source file" })
vim.keymap.set("n", "<localleader>.", ":.lua<cr>", { buffer = bufnr, desc = "lua: run line" })
vim.keymap.set("x", "<localleader>.", ":lua<cr>", { buffer = bufnr, desc = "lua: run" })

vim.keymap.set("n", "<localleader>dl", function() require("osv").launch({ port = 8086 }) end, {
  buffer = bufnr,
  desc = "Launch debugger",
})

vim.api.nvim_buf_create_user_command(bufnr, "RunAllTests", function() MiniTest.run() end, {
  nargs = 0,
  desc = "mini: run all tests",
})

vim.api.nvim_buf_create_user_command(bufnr, "RunTest", function() MiniTest.run_at_location() end, {
  nargs = 0,
  desc = "mini: run test",
})

vim.api.nvim_buf_create_user_command(bufnr, "GenerateDocs", function() MiniDoc.generate() end, {
  nargs = 0,
  desc = "mini: generate docs",
})
