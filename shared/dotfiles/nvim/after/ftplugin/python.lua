require("plugins.dap")

local dap_python = require("dap-python")

local map = require("utils").map

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
dap_python.test_runner = "pytest"

map({
	key = "<localleader>m",
	command = dap_python.test_method,
	desc = "DAP: test method",
	buffer = 0,
})

map({
	key = "<localleader>c",
	command = dap_python.test_class,
	desc = "DAP: test class",
	buffer = 0,
})

map({
	key = "<localleader>s",
	command = dap_python.debug_selection,
	desc = "DAP: debug region",
	buffer = 0,
})
