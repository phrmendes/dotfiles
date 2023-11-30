local dap = require("dap")
local dap_ui = require("dapui")
local wk = require("which-key")
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

wk.register({
	["<F1>"] = { dap.continue, "DAP: continue" },
	["<F2>"] = { dap.step_over, "DAP: step over" },
	["<F3>"] = { dap.step_into, "DAP: step into" },
	["<F4>"] = { dap.step_out, "DAP: step out" },
	["<F5>"] = { dap.step_back, "DAP: step back" },
	["<F6>"] = { dap.pause, "DAP: pause" },
	["<F7>"] = { dap.close, "DAP: quit" },
	b = { dap.toggle_breakpoint, "DAP: toggle breakpoint" },
	B = {
		function()
			local condition = ""
			vim.ui.select({
				prompt = "Condition: ",
			}, function(input)
				condition = input
			end)
			dap.set_breakpoint(condition)
		end,
		"DAP: conditional breakpoint",
	},
	t = { dap_ui.toggle, "DAP: toggle UI" },
}, { prefix = "<localleader>", mode = "n", buffer = 0 })

require("plugins.dap.icons")
require("plugins.dap.go")
require("plugins.dap.python")
