local augroup = require("utils").augroup
local map = require("utils").map

local autocommand = vim.api.nvim_create_autocmd

local dap_settings = function()
	local dap = require("dap")
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
		description = "DAP: step back",
	})

	map({
		key = "<F4>",
		command = dap.step_into,
		buffer = 0,
		description = "DAP: step into",
	})

	map({
		key = "<F6>",
		command = dap.continue,
		buffer = 0,
		description = "DAP: continue",
	})

	map({
		key = "<F7>",
		command = dap.step_over,
		buffer = 0,
		description = "DAP: step over",
	})

	map({
		key = "<F8>",
		command = dap.step_out,
		buffer = 0,
		description = "DAP: step out",
	})

	map({
		key = "<F11>",
		command = dap.close,
		buffer = 0,
		description = "DAP: quit",
	})

	map({
		key = "<S-F6>",
		command = dap.pause,
		buffer = 0,
		description = "DAP: pause",
	})

	map({
		key = "<localleader>b",
		command = dap.toggle_breakpoint,
		buffer = 0,
		description = "DAP: toggle breakpoint",
	})

	map({
		key = "<localleader>t",
		command = dap_ui.toggle,
		buffer = 0,
		description = "DAP: toggle UI",
	})
end

local dap_python_settings = function()
	dap_settings()

	local dap_python = require("dap-python")

	dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
	dap_python.test_runner = "pytest"

	map({
		key = "<localleader>c",
		command = dap_python.test_class,
		buffer = 0,
		description = "DAP: test last",
	})

	map({
		key = "<localleader>m",
		command = dap_python.test_method,
		buffer = 0,
		description = "DAP: test method/function",
	})

	map({
		mode = "x",
		key = "<localleader>r",
		command = dap_python.debug_selection,
		buffer = 0,
		description = "DAP: debug region",
	})
end

autocommand("FileType", {
	pattern = "python",
	group = augroup,
	callback = dap_python_settings,
})
