local command = vim.api.nvim_create_user_command

local M = {
	random = function()
		local opts = { nargs = 0 }

		opts.desc = "Select session"
		command("Sessions", function()
			require("mini.sessions").select()
		end, opts)
	end,
}

M.setup = function()
	M.random()
end

return M
