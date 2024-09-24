local command = vim.api.nvim_create_user_command
local buf_command = vim.api.nvim_buf_create_user_command

local M = {
	random = function()
		local opts = { nargs = 0 }

		opts.desc = "Open a scratch buffer"
		command("Scratch", function()
			local buf = vim.api.nvim_get_current_buf()

			vim.cmd("bel 10new")

			for name, value in pairs({
				filetype = "scratch",
				buftype = "nofile",
				bufhidden = "hide",
				swapfile = false,
				modifiable = true,
			}) do
				vim.api.nvim_set_option_value(name, value, { buf = buf })
			end
		end, opts)

		opts.desc = "Select session"
		command("Sessions", require("mini.sessions").select, opts)
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
