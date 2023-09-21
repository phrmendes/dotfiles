local fn = vim.fn

local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_ui.setup()
dap_virtual_text.setup()
dap_python.setup("~/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "unittest"

dap.listeners.after.event_initialized["dapui_config"] = function()
    dap_ui.open()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dap_ui.close()
end

-- nicer breakpoints
fn.sign_define("DapBreakpoint", { text = "" })
fn.sign_define("DapStopped", { text = "" })
