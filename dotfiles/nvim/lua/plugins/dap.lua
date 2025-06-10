local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({ source = "igorlfs/nvim-dap-view", depends = { "mfussenegger/nvim-dap" } })
	add({ source = "leoluz/nvim-dap-go", depends = { "mfussenegger/nvim-dap" } })
	add({ source = "mfussenegger/nvim-dap-python", depends = { "mfussenegger/nvim-dap" } })
	add({ source = "jbyuki/one-small-step-for-vimkind", depends = { "mfussenegger/nvim-dap" } })

	local dap = require("dap")
	local dap_view = require("dap-view")
	local dap_icons = { Breakpoint = " ", BreakpointCondition = " ", BreakpointRejected = " ", Stopped = " " }
	local dap_configs = {
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
			type = "lua",
			request = "attach",
			name = "Attach to running Neovim instance",
		},
	}

	dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
	dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
	dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
	dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end

	dap.adapters.lua = function(callback, config)
		callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
	end

	require("dap-go").setup()
	require("dap-python").setup(vim.fn.exepath("nvim-python3"))

	vim.iter(pairs(dap_icons)):each(function(type, icon)
		local thl = "Dap" .. type
		local nhl = (type == "Stopped") and "DapStop" or "DapBreak"
		vim.fn.sign_define(thl, { text = icon, texthl = thl, numhl = nhl })
	end)

	vim.iter(dap_configs):each(function(config)
		local lang = config.type

		dap.configurations[lang] = dap.configurations[lang] or {}
		table.insert(dap.configurations[lang], config)
	end)
end)
