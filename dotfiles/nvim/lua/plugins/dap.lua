local dap = require("dap")
local dap_ui = require("dapui")
local python

if vim.env.VIRTUAL_ENV then
	python = vim.env.VIRTUAL_ENV .. "/bin/python"
else
	python = vim.fn.exepath("nvim-python3")
end

require("dap-go").setup()
require("dap-python").setup(python)
require("nvim-dap-virtual-text").setup()

local dap_signs = {
	Breakpoint = "",
	BreakpointRejected = "",
	Stopped = "",
}

for type, icon in pairs(dap_signs) do
	local hl = "Dap" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap_ui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close
