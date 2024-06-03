local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")

local dap_signs = {
	Breakpoint = "",
	BreakpointRejected = "",
	Stopped = "",
}

for type, icon in pairs(dap_signs) do
	local hl = "Dap" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

require("nvim-dap-virtual-text").setup()
require("dap-go").setup()

dap_ui.setup()
dap_python.setup("nvim-python3")

dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close
dap_python.test_runner = "pytest"
