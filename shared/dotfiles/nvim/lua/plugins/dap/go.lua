local dap_go = require("dap-go")
local wk = require("which-key")

dap_go.setup()

wk.register({
	name = "go",
	m = { dap_go.debug_test, "DAP: debug test" },
}, { prefix = "<leader>dg", mode = "n", buffer = 0 })
