local ft = { "elixir", "go", "lua", "python" }

return {
	{
		"mfussenegger/nvim-dap",
		ft = ft,
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				ft = ft,
				dependencies = { "mfussenegger/nvim-dap" },
				opts = {},
				config = function()
					require("dap").listeners.before.attach["dap-view-config"] = function() require("dap-view").open() end
					require("dap").listeners.before.launch["dap-view-config"] = function() require("dap-view").open() end
					require("dap").listeners.before.event_terminated["dap-view-config"] = function() require("dap-view").close() end
					require("dap").listeners.before.event_exited["dap-view-config"] = function() require("dap-view").close() end
				end,
				keys = {
					{ "<localleader>du", function() require("dap-view").toggle() end, desc = "Toggle UI", ft = ft },
				},
			},
		},
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
			{ "<bs>", function() require("dap").close() end, desc = "DAP: close", ft = ft },
			{ "<localleader>d", "", desc = "+DAP", ft = ft },
			{ "<localleader>dd", function() require("dap").run_last() end, desc = "Debug last", ft = ft },
			{ "<localleader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint", ft = ft },
			{ "<localleader>di", function() require("dap").step_into() end, desc = "Step into", ft = ft },
			{ "<localleader>dk", function() require("dap.ui.widgets").hover() end, desc = "Show hover", ft = ft },
			{ "<localleader>do", function() require("dap").step_out() end, desc = "Step out", ft = ft },
			{ "<localleader>dq", function() require("dap").terminate() end, desc = "Terminate", ft = ft },
			{ "<localleader>d<del>", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoints", ft = ft },
			{
				"<localleader>dc",
				function()
					vim.ui.input({ prompt = "Condition: " }, function(input) require("dap").set_breakpoint(input) end)
				end,
				desc = "Conditional breakpoint",
				ft = ft,
			},
		},
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
		keys = {
			{ "<localleader>dg", "", desc = "+go", ft = "go" },
			{ "<localleader>dgd", function() require("dap-go").debug_test() end, desc = "Debug test", ft = "go" },
			{ "<localleader>dgl", function() require("dap-go").debug_last() end, desc = "Debug last", ft = "go" },
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
			{ "<localleader>dp", "", desc = "+python", ft = "python" },
			{ "<localleader>dpc", function() require("dap-python").test_class() end, desc = "Debug class", ft = "python" },
			{
				"<localleader>dpf",
				function() require("dap-python").test_method() end,
				desc = "Debug function/method",
				ft = "python",
			},
			{
				"<localleader>dpd",
				function() require("dap-python").debug_selection() end,
				desc = "Debug selection",
				ft = "python",
				mode = "x",
			},
		},
	},
	{
		"jbyuki/one-small-step-for-vimkind",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "lua",
		config = function()
			require("dap").configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			require("dap").adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
		end,
		keys = {
			{
				"<localleader>dl",
				function() require("osv").launch({ port = 8086 }) end,
				desc = "lua: launch debugger server",
				ft = "lua",
			},
		},
	},
}
