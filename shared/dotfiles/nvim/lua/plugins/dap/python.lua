local M = {}

M.setup = function()
	local map = require("utils").map

	local dap_python = require("dap-python")

	dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
	dap_python.test_runner = "pytest"

	map({
		key = "<localleader>c",
		command = dap_python.test_class,
		buffer = 0,
		desc = "DAP (python): test last",
	})

	map({
		key = "<localleader>f",
		command = dap_python.test_method,
		buffer = 0,
		desc = "DAP (python): test method/function",
	})

	map({
		mode = "v",
		key = "<localleader>d",
		command = dap_python.debug_selection,
		buffer = 0,
		desc = "DAP (python): debug region",
	})
end

return M
