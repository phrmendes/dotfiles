local dap, dap_ui = require("dap"), require("dapui")
local dap_go, dap_python = require("dap-go"), require("dap-python")
local fn = vim.fn

-- dap settings
dap_ui.setup()
dap_go.setup()
dap_python.setup("~/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

-- open dap ui automatically when a new debug session is created
dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end

-- nicer breakpoints
fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
fn.sign_define("DapStopped", { text = "▶", texthl = "", linehl = "", numhl = "" })
