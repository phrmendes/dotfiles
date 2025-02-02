local dap = require("dap")
local dap_ui = require("dapui")
local utils = require("utils")

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

require("plugins.dap.elixir").elixir_debug_adapter()
require("plugins.dap.go").delve()
require("plugins.dap.lua").osv()
require("plugins.dap.python").debugpy()
