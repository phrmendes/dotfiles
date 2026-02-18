local bufnr = vim.api.nvim_get_current_buf()

vim.opt_local.shiftwidth = 2

require("keymaps.lua")(bufnr)
require("keymaps.dap")(bufnr)
require("keymaps.refactoring")(bufnr)

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
