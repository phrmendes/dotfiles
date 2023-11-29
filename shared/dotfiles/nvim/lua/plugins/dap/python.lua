local dap_python = require("dap-python")
local wk = require("which-key")

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

wk.register({
	name = "python",
	m = { dap_python.test_method, "DAP: test method" },
	c = { dap_python.test_class, "DAP: test class" },
}, { prefix = "<leader>dp", mode = "n", buffer = 0 })

wk.register({
	name = "debug/diagnostics",
	d = { dap_python.debug_selection, "DAP: (python) debug selection" },
}, { prefix = "<leader>d", mode = "x", buffer = 0 })
