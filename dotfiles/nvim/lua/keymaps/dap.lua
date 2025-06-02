local map = vim.keymap.set

return function(bufnr)
	map("n", "<F7>", function() require("dap").step_back() end, { buffer = bufnr, desc = "DAP: step back" })
	map("n", "<F8>", function() require("dap").continue() end, { buffer = bufnr, desc = "DAP: continue" })
	map("n", "<F9>", function() require("dap").step_over() end, { buffer = bufnr, desc = "DAP: step over" })
	map("n", "<S-F8>", function() require("dap").pause() end, { buffer = bufnr, desc = "DAP: pause" })
	map("n", "<BS>", function() require("dap").close() end, { buffer = bufnr, desc = "DAP: close" })
	map("n", "<localleader>d", "", { buffer = bufnr, desc = "+dap" })
	map("n", "<localleader>dd", function() require("dap").run_last() end, { buffer = bufnr, desc = "Debug last" })
	map("n", "<localleader>di", function() require("dap").step_into() end, { buffer = bufnr, desc = "Step into" })
	map("n", "<localleader>do", function() require("dap").step_out() end, { buffer = bufnr, desc = "Step out" })
	map("n", "<localleader>dq", function() require("dap").terminate() end, { buffer = bufnr, desc = "Terminate" })
	map("n", "<localleader>du", function() require("dap-view").toggle() end, { buffer = bufnr, desc = "Toggle UI" })

	map("n", "<localleader>d<del>", function() require("dap").clear_breakpoints() end, {
		buffer = bufnr,
		desc = "Clear breakpoints",
	})

	map("n", "<localleader>db", function() require("dap").toggle_breakpoint() end, {
		buffer = bufnr,
		desc = "Breakpoint",
	})

	map("n", "<localleader>dB", function()
		vim.ui.input({ prompt = "Condition: " }, function(input) require("dap").set_breakpoint(input) end)
	end, { buffer = bufnr, desc = "Conditional breakpoint" })
end
