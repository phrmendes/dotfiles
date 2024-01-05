local map = require("utils").map
local dap = require("dap")

local M = {}

M.setup = function()
	local dap_ui = require("dapui")
	local dap_virtual_text = require("nvim-dap-virtual-text")

	local dap_signs = {
		Breakpoint = "",
		BreakpointRejected = "",
		Stopped = "",
	}

	for type, icon in pairs(dap_signs) do
		local hl = "Dap" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

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

	map({
		key = "<F3>",
		command = dap.step_back,
		buffer = 0,
		desc = "DAP: step back",
	})

	map({
		key = "<F4>",
		command = dap.step_into,
		buffer = 0,
		desc = "DAP: step into",
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
		key = "<F8>",
		command = dap.step_out,
		buffer = 0,
		desc = "DAP: step out",
	})

	map({
		key = "<F11>",
		command = dap.close,
		buffer = 0,
		desc = "DAP: quit",
	})

	map({
		key = "<S-F6>",
		command = dap.pause,
		buffer = 0,
		desc = "DAP: pause",
	})

	map({
		key = "<localleader>b",
		command = dap.toggle_breakpoint,
		buffer = 0,
		desc = "DAP: toggle breakpoint",
	})

	map({
		key = "<localleader>t",
		command = dap_ui.toggle,
		buffer = 0,
		desc = "DAP: toggle UI",
	})
end

M.python = function()
	local dap_python = require("dap-python")

	dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
	dap_python.test_runner = "pytest"

	map({
		key = "<localleader>c",
		command = dap_python.test_class,
		buffer = 0,
		desc = "DAP: test last",
	})

	map({
		key = "<localleader>m",
		command = dap_python.test_method,
		buffer = 0,
		desc = "DAP: test method/function",
	})

	map({
		mode = "v",
		key = "<localleader>r",
		command = dap_python.debug_selection,
		buffer = 0,
		desc = "DAP: debug region",
	})
end

M.scala = function()
	dap.configurations.scala = {
		{
			type = "scala",
			request = "launch",
			name = "RunOrTest",
			metals = {
				runType = "runOrTestFile",
			},
		},
		{
			type = "scala",
			request = "launch",
			name = "Test Target",
			metals = {
				runType = "testTarget",
			},
		},
	}
end

return M
