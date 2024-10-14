local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local utils = require("utils")

local elixir_ls_debugger = vim.fn.exepath("elixir-debug-adapter")
local vscode_js_debugger = vim.fn.exepath("js-debug-adapter")

dap_ui.setup()
dap_python.setup(vim.fn.exepath("nvim-python3"))
require("dap-go").setup()
require("nvim-dap-virtual-text").setup({ display_callback = utils.display_callback })
utils.setup_dap_signs({ Breakpoint = "", BreakpointRejected = "", Stopped = "" })

dap.listeners.after.event_initialized["dapui_config"] = dap_ui.open
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

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
