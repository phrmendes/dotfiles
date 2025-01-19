return {
	elixir_debug_adapter = function()
		local dap = require("dap")

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
	end,
}
