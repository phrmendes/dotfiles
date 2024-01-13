local M = {}

M.setup = function()
	local dap_signs = {
		Breakpoint = "",
		BreakpointRejected = "",
		Stopped = "",
	}

	for type, icon in pairs(dap_signs) do
		local hl = "Dap" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

return M
