safely("later", function() require("mini.test").setup() end)

safely("filetype:lua", function()
  vim.api.nvim_buf_create_user_command(0, "RunAllTests", function() require("mini.test").run() end, { desc = "mini: run all tests" })
  vim.api.nvim_buf_create_user_command(0, "RunTest", function() require("mini.test").run_at_location() end, { desc = "mini: run test" })
end)
