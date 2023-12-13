local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("DapConfig", { clear = true })

local map = function(key, value, desc, type)
	if type == nil then
		type = "n"
	end

	vim.keymap.set(type, key, value, { buffer = 0, desc = "DAP: " .. desc })
end

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

	map("<F3>", dap.step_back, "step back")
	map("<F4>", dap.step_into, "step into")
	map("<F6>", dap.continue, "continue")
	map("<F7>", dap.step_over, "step over")
	map("<F8>", dap.step_out, "step out")
	map("<S-F6>", dap.pause, "pause")
	map("<localleader>b", dap.toggle_breakpoint, "toggle breakpoint")
	map("<localleader>q", dap.close, "quit")
	map("<localleader>t", dap_ui.toggle, "toggle UI")
end

local dap_python_settings = function()
	dap_settings()

	local dap_python = require("dap-python")

	dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/tools/bin/python")
	dap_python.test_runner = "pytest"

	map("<localleader>c", dap_python.test_class, "thest class")
	map("<localleader>m", dap_python.test_method, "test method")
	map("<localleader>s", dap_python.debug_selection, "debug region")
end

autocmd("FileType", {
	pattern = "python",
	group = group,
	callback = function()
		dap_python_settings()
	end,
})
