local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

local map = vim.keymap.set

local M = {}

M.config = function()
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
end

M.keymaps = function()
	map("n", "<F1>", dap.continue, { desc = "DAP: continue", silent = true })
	map("n", "<F2>", dap.step_over, { desc = "DAP: step over", silent = true })
	map("n", "<F3>", dap.step_into, { desc = "DAP: step into", silent = true })
	map("n", "<F5>", dap.step_out, { desc = "DAP: step out", silent = true })
	map("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
	map("n", "<Leader>dl", dap.run_last, { desc = "Run last" })
	map("n", "<Leader>dt", dap_ui.toggle, { desc = "See last session result" })
	map("x", "<Leader>dp", dap_python.debug_selection, { desc = "Python: debug selection" })

	map("x", "<Leader>dc", function()
		dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
	end, { desc = "Condition breakpoint" })
end

return M
