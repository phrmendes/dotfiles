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

setup.neovim = function()
	dap.adapters.nlua = function(callback, config)
		local adapter = {
			type = "server",
			host = config.host or "127.0.0.1",
			port = config.port or 8086,
		}
		if config.start_neovim then
			local dap_run = dap.run

			dap.run = function(c)
				adapter.port = c.port
				adapter.host = c.host
			end

			require("osv").run_this()

			dap.run = dap_run
		end

		callback(adapter)
	end
	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Run this file",
			start_neovim = {},
		},
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance (port = 8086)",
			port = 8086,
		},
	}
end

setup.go = function()
	require("dap-go").setup()
end

setup.python = function()
	require("dap-python").setup(vim.fn.exepath("nvim-python3"))

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

setup.js_ts = function()
	require("dap-vscode-js").setup({
		debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
		adapters = { "pwa-node", "pwa-chrome" },
	})

	for _, language in ipairs({ "javascript", "typescript" }) do
		dap.configurations[language] = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch current file in new node process",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach debugger to existing `node --inspect` process",
				cwd = "${workspaceFolder}/src",
				processId = require("dap.utils").pick_process,
				sourceMaps = true,
				resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
			{
				type = "pwa-chrome",
				request = "launch",
				name = "Launch Chrome to debug client side code",
				url = "http://localhost:5173",
				sourceMaps = true,
				webRoot = "${workspaceFolder}/src",
				protocol = "inspector",
				port = 9222,
				skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
			},
		}
	end
end

for _, fn in pairs(setup) do
	fn()
end
