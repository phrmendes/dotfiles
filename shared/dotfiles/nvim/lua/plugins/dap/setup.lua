require("plugins.dap.ui")

local dap = require("dap")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

local map = require("utils").map

dap_ui.setup()
dap_virtual_text.setup()

dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

map({
	key = "<F3>",
	command = dap.step_out,
	buffer = 0,
	desc = "DAP: step out",
})

map({
	key = "<F4>",
	command = dap.step_into,
	buffer = 0,
	desc = "DAP: step into",
})

map({
	key = "<F5>",
	command = dap.step_back,
	buffer = 0,
	desc = "DAP: step back",
})

map({
	key = "<F6>",
	command = dap.continue,
	buffer = 0,
	desc = "DAP: continue",
})

map({
	key = "<F7>",
	command = dap.step_over,
	buffer = 0,
	desc = "DAP: step over",
})

map({
	key = "<S-F6>",
	command = dap.pause,
	buffer = 0,
	desc = "DAP: pause",
})

map({
	key = "<BS>",
	command = dap.close,
	buffer = 0,
	desc = "DAP: quit",
})

map({
	key = "<leader>t",
	command = dap.toggle_breakpoint,
	buffer = 0,
	desc = "DAP: toggle breakpoint",
})

map({
	key = "<leader>U",
	command = dap_ui.toggle,
	buffer = 0,
	desc = "DAP: toggle UI",
})
