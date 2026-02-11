return function(bufnr)
  vim.keymap.set({ "n", "x" }, "<leader>r", "", { buffer = bufnr, desc = "+refactoring" })
  vim.keymap.set({ "n", "x" }, "<leader>re", "", { buffer = bufnr, desc = "+extract" })
  vim.keymap.set({ "n", "x" }, "<leader>ri", "", { buffer = bufnr, desc = "+inline" })

  vim.keymap.set({ "n", "x" }, "<leader>ref", function() return require("refactoring").refactor("Extract Function") end, {
    buffer = bufnr,
    desc = "Function",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>reF", function() return require("refactoring").refactor("Extract Function To File") end, {
    buffer = bufnr,
    desc = "Function to file",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>rev", function() return require("refactoring").refactor("Extract Variable") end, {
    buffer = bufnr,
    desc = "Variable",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>reb", function() return require("refactoring").refactor("Extract Block") end, {
    buffer = bufnr,
    desc = "Block",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>reB", function() return require("refactoring").refactor("Extract Block To File") end, {
    buffer = bufnr,
    desc = "Block to file",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>rif", function() return require("refactoring").refactor("Inline Function") end, {
    buffer = bufnr,
    desc = "Function",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>riv", function() return require("refactoring").refactor("Inline Variable") end, {
    buffer = bufnr,
    desc = "Variable",
    expr = true,
  })

  vim.keymap.set({ "n", "x" }, "<leader>rp", function() require("refactoring").debug.print_var({}) end, {
    buffer = bufnr,
    desc = "Print variable",
  })

  vim.keymap.set("n", "<leader>rc", function() require("refactoring").debug.cleanup({}) end, {
    buffer = bufnr,
    desc = "Clear print statements",
  })
end
