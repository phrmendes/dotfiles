local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

local map = vim.keymap.set

local opts = { noremap = true, silent = true }

dap_ui.setup()
dap_virtual_text.setup()

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

dap.configurations.scala = {
	{
		type = "scala",
		request = "launch",
		name = "Run or test",
		metals = {
			runType = "runOrTestFile",
		},
	},
	{
		type = "scala",
		request = "launch",
		name = "Test target",
		metals = {
			runType = "testTarget",
		},
	},
}

dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end

local description = function(desc)
	opts.desc = "DAP: " .. desc
end

description("continue")
map("n", "<F1>", dap.continue, opts)

description("step over")
map("n", "<F2>", dap.step_over, opts)

description("step into")
map("n", "<F3>", dap.step_into, opts)

description("step out")
map("n", "<F5>", dap.step_out, opts)

description("toggle breakpoint")
map("n", "<Leader>db", dap.toggle_breakpoint, opts)

description("run last")
map("n", "<Leader>dl", dap.run_last, opts)

description("see last session result")
map("n", "<Leader>dt", dap_ui.toggle, opts)

description("(python) debug selection")
map("x", "<Leader>dp", dap_python.debug_selection, opts)

description("conditional breakpoint")
map("x", "<Leader>dc", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
end, opts)
