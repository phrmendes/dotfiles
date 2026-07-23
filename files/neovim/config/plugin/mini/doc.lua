safely("later", function() require("mini.doc").setup() end)

safely("filetype:lua", function()
  vim.api.nvim_buf_create_user_command(0, "GenerateDocs", function() require("mini.doc").generate() end, { desc = "mini: generate docs" })
end)
