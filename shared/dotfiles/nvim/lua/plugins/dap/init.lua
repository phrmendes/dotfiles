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

local map = function(key, value, desc)
	vim.keymap.set("n", "<localleader>" .. key, value, { buffer = true, desc = "DAP: " .. desc })
end

local conditional_breakpoint = function()
	local condition = ""
	vim.ui.select({
		prompt = "Condition: ",
	}, function(input)
		condition = input
	end)
	dap.set_breakpoint(condition)
end

map("<F1>", dap.continue, "continue")
map("<F2>", dap.step_over, "step over")
map("<F3>", dap.step_into, "step into")
map("<F4>", dap.step_out, "step out")
map("<F5>", dap.step_back, "step back")
map("<F6>", dap.pause, "pause")
map("<F7>", dap.close, "quit")
map("b", dap.toggle_breakpoint, "toggle breakpoint")
map("B", conditional_breakpoint, "conditional breakpoint")
map("t", dap_ui.toggle, "toggle UI")

require("plugins.dap.icons")
require("plugins.dap.python")
