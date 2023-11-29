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
	name = "debug/diagnostics",
	b = { dap.toggle_breakpoint, "DAP: toggle breakpoint" },
	d = { "<cmd>TroubleToggle document_diagnostics<cr>", "LSP: document diagnostics" },
	f = { vim.diagnostic.open_float, "LSP: floating diagnostics message" },
	l = { dap.run_last, "DAP: run last" },
	r = { dap.repl.open, "DAP: open REPL" },
	t = { dap_ui.toggle, "DAP: toggle UI" },
	w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "LSP: workspace diagnostics" },
	B = {
		function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
		end,
		"DAP: conditional breakpoint",
	},
}, { prefix = "<leader>d", mode = "n", buffer = 0 })

wk.register({
	["<F1>"] = { dap.continue, "DAP: continue" },
	["<F2>"] = { dap.step_over, "DAP: step over" },
	["<F3>"] = { dap.step_into, "DAP: step into" },
	["<F4>"] = { dap.step_out, "DAP: step out" },
}, { prefix = "<localleader>", mode = "n", buffer = 0 })

require("plugins.dap.icons")
require("plugins.dap.go")
require("plugins.dap.python")
