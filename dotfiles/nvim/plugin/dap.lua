local icons = {
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = " ",
	Stopped = " ",
}

local configs = {
	{
		type = "python",
		request = "launch",
		name = "django:server",
		program = vim.uv.cwd() .. "/manage.py",
		args = function() return { "runserver", "--noreload", vim.fn.input("Port: ", "8000") } end,
		justMyCode = true,
		django = true,
		console = "integratedTerminal",
	},
	{
		type = "python",
		request = "launch",
		name = "fastapi:server",
		module = "fastapi",
		args = function()
			return { "run", vim.fn.input("Entrypoint: ", "src/main.py"), "--port", vim.fn.input("Port: ", "8000") }
		end,
		justMyCode = true,
		console = "integratedTerminal",
	},
	{
		type = "python",
		name = "remote",
		request = "attach",
		mode = "remote",
		connect = function()
			return {
				host = vim.fn.input("Host: ", "localhost"),
				port = tonumber(vim.fn.input("Port: ", "5678")),
			}
		end,
		pathMappings = function()
			return {
				{
					localRoot = vim.fn.input("Local path: ", "${workspaceFolder}"),
					remoteRoot = vim.fn.input("Remote path: ", "."),
				},
			}
		end,
	},
	{
		type = "lua",
		request = "attach",
		name = "Attach to running Neovim instance",
	},
	{
		type = "mix_task",
		name = "mix:test",
		request = "launch",
		task = "test",
		taskArgs = { "--trace" },
		startApps = true,
		projectDir = "${workspaceFolder}",
		requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
	},
	{
		type = "mix_task",
		name = "phoenix:server",
		request = "launch",
		task = "phx.server",
		projectDir = "${workspaceRoot}",
		exitAfterTaskReturns = false,
		debugAutoInterpretAlModules = false,
	},
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
		processId = function() require("dap.utils").pick_process() end,
		name = "Attach debugger to existing `node --inspect` process",
		sourceMaps = true,
		resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
		cwd = "${workspaceFolder}/src",
		skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
	},
	{
		type = "pwa-chrome",
		request = "launch",
		name = "Launch Chrome to debug client side code",
		url = function() return vim.fn.input("URL: ", "http://localhost:5173") end,
		sourceMaps = true,
		webRoot = "${workspaceFolder}/src",
		protocol = "inspector",
		port = 9222,
		skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
	},
}

local adapters = {
	lua = { type = "server", host = "127.0.0.1", port = 8086 },
	["pwa-node"] = {
		type = "server",
		port = "${port}",
		executable = { command = require("nix.vscode-js-debug"), args = { "${port}" } },
	},
}

MiniDeps.later(function()
	MiniDeps.add({ source = "igorlfs/nvim-dap-view", depends = { "mfussenegger/nvim-dap" } })
	MiniDeps.add({ source = "leoluz/nvim-dap-go", depends = { "mfussenegger/nvim-dap" } })
	MiniDeps.add({ source = "mfussenegger/nvim-dap-python", depends = { "mfussenegger/nvim-dap" } })
	MiniDeps.add({ source = "jbyuki/one-small-step-for-vimkind", depends = { "mfussenegger/nvim-dap" } })

	local dap = require("dap")
	local dap_view = require("dap-view")

	dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
	dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
	dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
	dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

	require("dap-go").setup()
	require("dap-python").setup(vim.fn.exepath("nvim-python3"))

	vim.iter(pairs(icons)):each(function(type, icon)
		local thl = "Dap" .. type
		local nhl = (type == "Stopped") and "DapStop" or "DapBreak"
		vim.fn.sign_define(thl, { text = icon, texthl = thl, numhl = nhl })
	end)

	vim.iter(configs):each(function(config)
		local type = config.type

		dap.configurations[type] = dap.configurations[type] or {}
		table.insert(dap.configurations[type], config)
	end)

	vim.iter(adapters):each(function(lang, adapter) dap.adapters[lang] = adapter end)
end)
