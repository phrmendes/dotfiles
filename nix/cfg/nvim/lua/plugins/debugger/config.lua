local dap = require("dap")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_ui.setup()
dap_virtual_text.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end
