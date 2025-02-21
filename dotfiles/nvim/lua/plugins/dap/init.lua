local ft = { "elixir", "lua", "python" }

return {
	"mfussenegger/nvim-dap",
	ft = ft,
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
		{ "<localleader>u", function() require("dapui").toggle() end, desc = "DAP: toggle UI", ft = ft },
		{ "<localleader>e", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP: eval", ft = ft },
		{
			"<localleader>C",
			function() require("dap").clear_breakpoints() end,
			desc = "DAP: clear all breakpoints",
			ft = ft,
		},
		{
			"<localleader>B",
			function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
			desc = "DAP: conditional breakpoint",
			ft = ft,
		},
		{
			"<localleader>c",
			function() require("dap-python").test_class() end,
			desc = "Python: debug class",
			ft = "python",
		},
		{
			"<localleader>f",
			function() require("dap-python").test_method() end,
			desc = "Python: debug function/method",
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
			"<localleader>r",
			function() require("osv").launch({ port = 8086 }) end,
			desc = "DAP: run lua DAP server",
			ft = "lua",
		},
	},
}
