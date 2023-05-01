local dap = require("dap")
local fn = vim.fn

local setup_ui, dap_ui = pcall(require, "dapui")
if not setup_ui then
	return
end

local setup_py, dap_python = pcall(require, "dap-python")
if not setup_py then
	return
end

local setup_go, dap_go = pcall(require, "dap-go")
if not setup_go then
	return
end

local setup_txt, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not setup_txt then
	return
end

-- dap settings
dap_ui.setup()
dap_go.setup()
dap_virtual_text.setup()
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
fn.sign_define("DapBreakpoint", { text = "🐞" })
fn.sign_define("DapStopped", { text = "▶" })
