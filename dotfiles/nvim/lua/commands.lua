local M = {
	ltex = function(bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "Ltex", function()
			if vim.g.ltex_language == "en-US" then
				vim.g.ltex_language = "pt-BR"
				vim.opt_local.spelllang = "pt"
				vim.notify("Setting language to `pt-BR`", vim.log.levels.INFO)
			else
				vim.g.ltex_language = "en-US"
				vim.notify("Setting language to `en-US`", vim.log.levels.INFO)
			end

			local client = vim.lsp.get_clients({ name = "ltex_plus" })[1]
			local settings = client.config.settings

			if not settings then
				return
			end

			settings.ltex.language = vim.g.ltex_language

			client.notify("workspace/didChangeConfiguration", { settings = settings })
		end, {
			desc = "Toggle Ltex Language",
			nargs = 0,
		})
	end,
}

return M
