local dap = require("dap")
local dap_ui = require("dapui")
local utils = require("utils")

local elixir_ls_debugger = vim.fn.exepath("elixir-debug-adapter")
local vscode_js_debugger = vim.fn.exepath("js-debug-adapter")
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

	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = python,
		},
		{
			type = "python",
			request = "launch",
			name = "Debug Django app",
			program = vim.uv.cwd() .. "/manage.py",
			args = { "runserver", "--noreload", "8001" },
			justMyCode = true,
			django = true,
			console = "integratedTerminal",
		},
		{
			type = "python",
			request = "attach",
			name = "Attach remote",
			connect = function()
				return {
					host = "127.0.0.1",
					port = 5678,
				}
			end,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch file with arguments",
			program = "${file}",
			args = function()
				local args_string = vim.fn.input("Arguments: ")
				return vim.split(args_string, " +")
			end,
			console = "integratedTerminal",
			pythonPath = python,
		},
	}
end

if vscode_js_debugger ~= "" then
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "127.0.0.1",
		port = 8123,
		executable = {
			command = vscode_js_debugger,
		},
	}

	for _, language in ipairs({ "typescript", "javascript" }) do
		dap.configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				runtimeExecutable = "node",
			},
		}
	end
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
