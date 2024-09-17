local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")

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
dap_python.setup()
dap_python.test_runner = "pytest"
dap_python.resolve_python = function()
	if vim.env.VIRTUAL_ENV or vim.env.CONDA_DEFAULT_ENV then
		return vim.env.VIRTUAL_ENV .. "/bin/python"
	end

	return vim.fn.exepath("nvim-python3")
end

require("dap-go").setup()

require("nvim-dap-virtual-text").setup({
	display_callback = function(variable)
		if #variable.value > 15 then
			return " " .. string.sub(variable.value, 1, 15) .. "... "
		end

		return " " .. variable.value
	end,
})

dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

local elixir_ls_debugger = vim.fn.exepath("elixir-debug-adapter")

if elixir_ls_debugger ~= "" then
	dap.adapters.mix_task = {
		type = "executable",
		command = elixir_ls_debugger,
	}

	dap.configurations.elixir = {
		{
			type = "mix_task",
			name = "mix test",
			request = "launch",
			task = "test",
			taskArgs = { "--trace" },
			startApps = true,
			projectDir = "${workspaceFolder}",
			requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
		},
		{
			type = "mix_task",
			name = "phoenix server",
			request = "launch",
			task = "phx.server",
			projectDir = "${workspaceRoot}",
			exitAfterTaskReturns = false,
			debugAutoInterpretAlModules = false,
		},
	}
end
