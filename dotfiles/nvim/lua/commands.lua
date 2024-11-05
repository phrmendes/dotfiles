local command = vim.api.nvim_create_user_command
local buf_command = vim.api.nvim_buf_create_user_command

local M = {
	random = function()
		local opts = { nargs = 0 }

		opts.desc = "Select session"
		command("Sessions", function()
			require("mini.sessions").select()
		end, opts)
	end,
	lsp = function(client, bufnr)
		if client.supports_method("textDocument/inlayHint") then
			local opts = { nargs = 0 }

			opts.desc = "LSP: toggle inlay hints"
			buf_command(bufnr, "ToggleInlayHints", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
			end, opts)
		end
	end,
}

M.setup = function()
	M.random()
end

return M
