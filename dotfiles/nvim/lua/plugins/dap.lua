local ft = { "elixir", "python", "go" }

return {
	{
		"mfussenegger/nvim-dap",
		ft = ft,
		config = function()
			local dap = require("dap")

			for type, icon in pairs({
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = " ",
				Stopped = " ",
			}) do
				local thl = "Dap" .. type
				local nhl = (type == "Stopped") and "DapStop" or "DapBreak"
				vim.fn.sign_define(thl, { text = icon, texthl = thl, numhl = nhl })
			end

			dap.adapters.mix_task = {
				type = "executable",
				command = vim.fn.exepath("elixir-debug-adapter"),
			}

			dap.configurations.elixir = {
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
			}
		end,
		keys = {
			{ "<f7>", function() require("dap").step_back() end, ft = ft, desc = "DAP: step back" },
			{ "<f8>", function() require("dap").continue() end, desc = "DAP: continue", ft = ft },
			{ "<f9>", function() require("dap").step_over() end, desc = "DAP: step over", ft = ft },
			{ "<s-f8>", function() require("dap").pause() end, desc = "DAP: pause", ft = ft },
			{ "<localleader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint", ft = ft },
			{ "<localleader>i", function() require("dap").step_into() end, desc = "DAP: step into", ft = ft },
			{ "<localleader>k", function() require("dap.ui.widgets").hover() end, desc = "DAP: show hover", ft = ft },
			{ "<localleader>l", function() require("dap").run_last() end, desc = "DAP: debug last", ft = ft },
			{ "<localleader>o", function() require("dap").step_out() end, desc = "DAP: step out", ft = ft },
			{ "<localleader>q", function() require("dap").terminate() end, desc = "DAP: terminate", ft = ft },
			{ "<localleader>s", function() require("dap").stop() end, desc = "DAP: stop", ft = ft },
			{
				"<localleader><del>",
				function() require("dap").clear_breakpoints() end,
				desc = "DAP: clear all breakpoints",
				ft = ft,
			},
			{
				"<localleader>B",
				function()
					vim.ui.input({ prompt = "Condition: " }, function(input) require("dap").set_breakpoint(input) end)
				end,
				desc = "DAP: conditional breakpoint",
				ft = ft,
			},
		},
	},
	{
		"igorlfs/nvim-dap-view",
		ft = ft,
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {},
		config = function()
			local dap, dap_view = require("dap"), require("dap-view")

			dap.listeners.before.attach["dap-view-config"] = function() dap_view.open() end
			dap.listeners.before.launch["dap-view-config"] = function() dap_view.open() end
			dap.listeners.before.event_terminated["dap-view-config"] = function() dap_view.close() end
			dap.listeners.before.event_exited["dap-view-config"] = function() dap_view.close() end
		end,
		keys = {
			{ "<localleader>u", function() require("dap-view").toggle() end, desc = "DAP: toggle UI", ft = ft },
		},
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
		keys = {
			{ "<localleader>g", "", desc = "+go", ft = "go" },
			{
				"<localleader>gd",
				function() require("dap-go").debug_test() end,
				desc = "DAP: debug test",
				ft = "go",
			},
			{
				"<localleader>gl",
				function() require("dap-go").debug_last() end,
				desc = "DAP: debug last",
				ft = "go",
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-python").setup(vim.fn.exepath("nvim-python3"))

			table.insert(require("dap").configurations.python, {
				type = "python",
				request = "launch",
				name = "django:server",
				program = vim.uv.cwd() .. "/manage.py",
				args = function() return { "runserver", "--noreload", vim.fn.input("Port: ", "8000") } end,
				justMyCode = true,
				django = true,
				console = "integratedTerminal",
			})

			table.insert(require("dap").configurations.python, {
				type = "python",
				request = "launch",
				name = "fastapi:server",
				module = "fastapi",
				args = function()
					return { "run", vim.fn.input("Entrypoint: ", "src/main.py"), "--port", vim.fn.input("Port: ", "8000") }
				end,
				justMyCode = true,
				console = "integratedTerminal",
			})
		end,
		keys = {
			{ "<localleader>p", "", desc = "+python", ft = "python" },
			{
				"<localleader>pc",
				function() require("dap-python").test_class() end,
				desc = "DAP: debug class",
				ft = "python",
			},
			{
				"<localleader>pd",
				function() require("dap-python").debug_selection() end,
				mode = "x",
				desc = "DAP: debug",
				ft = "python",
			},
			{
				"<localleader>pf",
				function() require("dap-python").test_method() end,
				desc = "DAP: debug function/method",
				ft = "python",
			},
		},
	},
}
