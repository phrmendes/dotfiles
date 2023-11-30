local dap_python = require("dap-python")
local wk = require("which-key")

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

wk.register({
	name = "python",
	m = { dap_python.test_method, "DAP (python): test method" },
	c = { dap_python.test_class, "DAP (python): test class" },
}, { prefix = "<localleader>", mode = "n", buffer = 0 })

wk.register({
	name = "debug/diagnostics",
	d = { dap_python.debug_selection, "DAP (python): debug selection" },
}, { prefix = "<localleader>", mode = "x", buffer = 0 })
