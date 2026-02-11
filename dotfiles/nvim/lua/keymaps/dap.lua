return function(bufnr)
  vim.keymap.set("n", "<F7>", function() require("dap").step_back() end, { buffer = bufnr, desc = "DAP: step back" })
  vim.keymap.set("n", "<F8>", function() require("dap").continue() end, { buffer = bufnr, desc = "DAP: continue" })
  vim.keymap.set("n", "<F9>", function() require("dap").step_over() end, { buffer = bufnr, desc = "DAP: step over" })
  vim.keymap.set("n", "<S-F8>", function() require("dap").pause() end, { buffer = bufnr, desc = "DAP: pause" })
  vim.keymap.set("n", "<BS>", function() require("dap").close() end, { buffer = bufnr, desc = "DAP: close" })
  vim.keymap.set("n", "<localleader>d", "", { buffer = bufnr, desc = "+dap" })

  vim.keymap.set("n", "<localleader>dd", function() require("dap").run_last() end, {
    buffer = bufnr,
    desc = "Debug last",
  })

  vim.keymap.set("n", "<localleader>di", function() require("dap").step_into() end, {
    buffer = bufnr,
    desc = "Step into",
  })

  vim.keymap.set("n", "<localleader>do", function() require("dap").step_out() end, {
    buffer = bufnr,
    desc = "Step out",
  })

  vim.keymap.set("n", "<localleader>dq", function() require("dap").terminate() end, {
    buffer = bufnr,
    desc = "Terminate",
  })

  vim.keymap.set("n", "<localleader>du", function() require("dap-view").toggle() end, {
    buffer = bufnr,
    desc = "Toggle UI",
  })

  vim.keymap.set("n", "<localleader>d<del>", function() require("dap").clear_breakpoints() end, {
    buffer = bufnr,
    desc = "Clear breakpoints",
  })

  vim.keymap.set("n", "<localleader>db", function() require("dap").toggle_breakpoint() end, {
    buffer = bufnr,
    desc = "Breakpoint",
  })

  vim.keymap.set("n", "<localleader>dB", function()
    vim.ui.input({ prompt = "Condition: " }, function(input) require("dap").set_breakpoint(input) end)
  end, { buffer = bufnr, desc = "Conditional breakpoint" })
end
