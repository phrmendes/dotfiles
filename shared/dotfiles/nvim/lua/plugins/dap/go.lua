local M = {}

M.setup = function()
	local dap_go = require("dap-go")

	dap_go.setup()

	require("utils").map({
		key = "<localleader>t",
		command = dap_go.debug_test,
		buffer = 0,
		desc = "DAP (go): debug test",
	})
end

return M
