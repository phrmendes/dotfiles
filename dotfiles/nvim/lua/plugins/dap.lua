local ft = { "elixir", "python" }

return {
	{
		"mfussenegger/nvim-dap",
		ft = ft,
		config = function()
			local dap = require("dap")

			for type, icon in pairs({
				Breakpoint = "",
				BreakpointCondition = "",
				BreakpointRejected = "",
				Stopped = "",
			}) do
				local hl = "Dap" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
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
		"rcarriga/nvim-dap-ui",
		ft = ft,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dap_ui = require("dapui")

			dap_ui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function() dap_ui.open({ reset = true }) end
			dap.listeners.before.event_terminated["dapui_config"] = function() dap_ui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dap_ui.close() end
		end,
		keys = {
			{ "<localleader>u", function() require("dapui").toggle() end, desc = "DAP: toggle UI", ft = ft },
			{ "<localleader>e", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP: eval", ft = ft },
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		ft = ft,
		dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-dap-virtual-text").setup({
				display_callback = function(variable)
					if #variable.value > 15 then return " " .. string.sub(variable.value, 1, 15) .. "... " end

					return " " .. variable.value
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap = require("dap")

			require("dap-python").setup(vim.fn.exepath("nvim-python3"))

			local config = dap.configurations.python or {}

			table.insert(config, {
				type = "python",
				request = "launch",
				name = "django:server",
				program = vim.uv.cwd() .. "/manage.py",
				args = function() return { "runserver", "--noreload", vim.fn.input("Port: ", "8000") } end,
				justMyCode = true,
				django = true,
				console = "integratedTerminal",
			})

			table.insert(config, {
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

			dap.configurations.python = config
		end,
		keys = {
			{
				"<localleader>c",
				function() require("dap-python").test_class() end,
				desc = "Python: debug class",
				ft = "python",
			},
			{
				"<localleader>d",
				function() require("dap-python").debug_selection() end,
				mode = "v",
				desc = "Python: debug",
				ft = "python",
			},
			{
				"<localleader>f",
				function() require("dap-python").test_method() end,
				desc = "Python: debug function/method",
				ft = "python",
			},
		},
	},
}
