local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = augroup,
	callback = function()
		local dap = require("dap")
		local dap_ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")
		local dap_python = require("dap-python")

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
		dap_python.setup(vim.fn.expand("~/.virtualenvs/tools/bin/python"))

		dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
		dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
		dap.listeners.before.event_exited["dapui_config"] = dap_ui.close
		dap_python.test_runner = "pytest"
	end,
})
