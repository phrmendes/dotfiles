local dap = require("dap")
local dap_ui = require("dapui")
local utils = require("utils")

local setup = {}

setup.ui = function()
	require("nvim-dap-virtual-text").setup({ display_callback = utils.display_callback })

	dap_ui.setup()

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dap_ui.open({ reset = true })
	end

	dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close

	dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

	utils.setup_dap_signs({
		Breakpoint = "",
		BreakpointRejected = "",
		Stopped = "",
	})
end

setup.python = function()
	require("dap-python").setup(vim.fn.exepath("nvim-python3"))

	local configs = dap.configurations.python or {}

	dap.configurations.python = configs

	table.insert(configs, {
		type = "python",
		request = "launch",
		name = "Debug Django app",
		program = vim.uv.cwd() .. "/manage.py",
		args = function()
			local input = vim.fn.input("Enter the port for the Django app: ", "8001")
			return { "runserver", "--noreload", input }
		end,
		justMyCode = true,
		django = true,
		console = "integratedTerminal",
	})

	table.insert(configs, {
		type = "python",
		request = "launch",
		name = "Debug FastAPI app",
		module = "fastapi",
		args = function()
			local input = vim.fn.input("Enter the path to the FastAPI app: ", "src/main.py")
			return { "run", input }
		end,
		justMyCode = true,
		console = "integratedTerminal",
	})
end

setup.elixir = function()
	dap.adapters.mix_task = {
		type = "executable",
		command = vim.fn.exepath("elixir-debug-adapter"),
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

for _, fn in pairs(setup) do
	fn()
end
