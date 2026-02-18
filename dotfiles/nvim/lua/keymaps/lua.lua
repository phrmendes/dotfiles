return function(buffer)
  vim.keymap.set("n", "<localleader>%", "<cmd>source %<cr>", { buffer = bufnr, desc = "lua: source file" })
  vim.keymap.set("n", "<localleader>.", ":.lua<cr>", { buffer = bufnr, desc = "lua: run line" })
  vim.keymap.set("n", "<localleader>dl", function() require("osv").launch({ port = 8086 }) end, { buffer = bufnr, desc = "Launch debugger" })
  vim.keymap.set("x", "<localleader>.", ":lua<cr>", { buffer = bufnr, desc = "lua: run" })
end
