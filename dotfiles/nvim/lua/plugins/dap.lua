local dap = require("dap")
local dap_ui = require("dapui")
local utils = require("utils")

local elixir_ls_debugger = vim.fn.exepath("elixir-debug-adapter")
local python = vim.fn.exepath("nvim-python3")

utils.setup_dap_signs({
	Breakpoint = "",
	BreakpointRejected = "",
	Stopped = "",
})

require("dap-go").setup()
require("nvim-dap-virtual-text").setup({ display_callback = utils.display_callback })

dap_ui.setup()
dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

if python ~= "" then
	require("dap-python").setup(python)

	local configs = dap.configurations.python or {}
	dap.configurations.python = configs

	table.insert(configs, {
		type = "python",
		request = "launch",
		name = "Launch Django app",
		program = vim.uv.cwd() .. "/manage.py",
		args = { "runserver", "--noreload", "8001" },
		justMyCode = true,
		django = true,
		console = "integratedTerminal",
	})

	table.insert(configs, {
		type = "python",
		request = "launch",
		name = "Launch FastAPI app",
		program = "fastapi",
		args = function()
			return {
				vim.fn.input("File: ", vim.uv.cwd() .. "/main.py"),
				"--use-colors",
			}
		end,
		pythonPath = "python",
		console = "integratedTerminal",
	})
end

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

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
}
