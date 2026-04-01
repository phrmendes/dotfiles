safely("filetype:python,lua,javascript,typescript", function()
  local refactoring = require("refactoring")
  local modes = { "n", "x" }

  refactoring.setup({})

  vim.keymap.set(modes, "<leader>r", "", { desc = "+refactoring" })
  vim.keymap.set(modes, "<leader>re", "", { desc = "+extract" })
  vim.keymap.set(modes, "<leader>ri", "", { desc = "+inline" })
  vim.keymap.set(modes, "<leader>ref", function() return refactoring.refactor("Extract Function") end, { desc = "Function", expr = true })
  vim.keymap.set(modes, "<leader>rev", function() return refactoring.refactor("Extract Variable") end, { desc = "Variable", expr = true })
  vim.keymap.set(modes, "<leader>reb", function() return refactoring.refactor("Extract Block") end, { desc = "Block", expr = true })
  vim.keymap.set(modes, "<leader>rif", function() return refactoring.refactor("Inline Function") end, { desc = "Function", expr = true })
  vim.keymap.set(modes, "<leader>riv", function() return refactoring.refactor("Inline Variable") end, { desc = "Variable", expr = true })
  vim.keymap.set(modes, "<leader>rp", function() refactoring.debug.print_var({}) end, { desc = "Print variable" })
  vim.keymap.set("n", "<leader>rc", function() refactoring.debug.cleanup({}) end, { desc = "Clear print statements" })
  vim.keymap.set(modes, "<leader>reB", function() return refactoring.refactor("Extract Block To File") end, { desc = "Block to file", expr = true })
  vim.keymap.set(modes, "<leader>reF", function() return refactoring.refactor("Extract Function To File") end, {
    desc = "Function to file",
    expr = true,
  })
end)
