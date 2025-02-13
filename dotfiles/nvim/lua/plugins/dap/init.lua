return {
	"mfussenegger/nvim-dap",
	ft = { "elixir", "lua", "python" },
	dependencies = {
		"jbyuki/one-small-step-for-vimkind",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dap_ui = require("dapui")
		local utils = require("utils")

		require("nvim-dap-virtual-text").setup({ display_callback = utils.display_callback })

		dap_ui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = function() dap_ui.open({ reset = true }) end

		dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close

		dap.listeners.before.event_exited["dapui_config"] = dap_ui.close

		utils.setup_dap_signs({
			Breakpoint = "",
			BreakpointRejected = "",
			Stopped = "",
		})

		require("plugins.dap.elixir_debug_adapter").setup()
		require("plugins.dap.osv").setup()
		require("plugins.dap.debugpy").setup()
	end,
	keys = {
		{ "<f7>", function() require("dap").step_back() end, desc = "DAP: step back" },
		{ "<f8>", function() require("dap").continue() end, desc = "DAP: continue" },
		{ "<f9>", function() require("dap").step_over() end, desc = "DAP: step over" },
		{ "<localleader>C", function() require("dap").clear_breakpoints() end, desc = "DAP: clear all breakpoints" },
		{ "<localleader>b", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
		{ "<localleader>i", function() require("dap").step_into() end, desc = "DAP: step into" },
		{ "<localleader>k", function() require("dap.ui.widgets").hover() end, desc = "DAP: show hover" },
		{ "<localleader>l", function() require("dap").run_last() end, desc = "DAP: debug last" },
		{ "<localleader>o", function() require("dap").step_out() end, desc = "DAP: step out" },
		{ "<localleader>q", function() require("dap").terminate() end, desc = "DAP: terminate" },
		{ "<localleader>u", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
		{ "<s-f8>", function() require("dap").pause() end, desc = "DAP: pause" },
		{
			"<localleader>e",
			function() require("dapui").eval(nil, { enter = true }) end,
			desc = "DAP: eval",
		},
		{
			"<localleader>B",
			function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
			desc = "DAP: conditional breakpoint",
		},
	},
}
