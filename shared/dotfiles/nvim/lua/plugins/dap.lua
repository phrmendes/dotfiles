local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("DapConfig", { clear = true })
local map = require("utils").map

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
		cmd = dap.step_back,
		buffer = 0,
		description = "DAP: step back",
	})

	map({
		key = "<F4>",
		cmd = dap.step_into,
		buffer = 0,
		description = "DAP: step into",
	})

	map({
		key = "<F6>",
		cmd = dap.continue,
		buffer = 0,
		description = "DAP: continue",
	})

	map({
		key = "<F7>",
		cmd = dap.step_over,
		buffer = 0,
		description = "DAP: step over",
	})

	map({
		key = "<F8>",
		cmd = dap.step_out,
		buffer = 0,
		description = "DAP: step out",
	})

	map({
		key = "<F11>",
		cmd = dap.close,
		buffer = 0,
		description = "DAP: quit",
	})

	map({
		key = "<S-F6>",
		cmd = dap.pause,
		buffer = 0,
		description = "DAP: pause",
	})

	map({
		key = "<localleader>b",
		cmd = dap.toggle_breakpoint,
		buffer = 0,
		description = "DAP: toggle breakpoint",
	})

	map({
		key = "<localleader>t",
		cmd = dap_ui.toggle,
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
		cmd = dap_python.test_class,
		buffer = 0,
		description = "DAP: test last",
	})

	map({
		key = "<localleader>m",
		cmd = dap_python.test_method,
		buffer = 0,
		description = "DAP: test method/function",
	})

	map({
		mode = "x",
		key = "<localleader>r",
		cmd = dap_python.debug_selection,
		buffer = 0,
		description = "DAP: debug region",
	})
end

autocmd("FileType", {
	pattern = "python",
	group = group,
	callback = function()
		dap_python_settings()
	end,
})
