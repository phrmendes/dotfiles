safely("filetype:python,lua,javascript,typescript", function()
  local refactoring = require("refactoring")
  local debug = require("refactoring.debug")

  refactoring.setup({})

  vim.keymap.set({ "n", "x" }, "<leader>r", "", { desc = "+refactoring" })
  vim.keymap.set({ "n", "x" }, "<leader>rr", refactoring.select_refactor, { desc = "Select refactor" })

  vim.keymap.set("n", "<leader>rv", function() return debug.print_var({ output_location = "below" }) .. "iw" end, {
    desc = "Print variable",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>re", function() return debug.print_exp({ output_location = "below" }) end, {
    desc = "Print expression",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>rc", function() return debug.cleanup({ restore_view = true }) end, {
    desc = "Cleanup print statements",
    expr = true,
    remap = true,
  })
end)
