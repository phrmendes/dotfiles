return {
	ltex = function(bufnr)
		bufnr = bufnr or vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_create_user_command(bufnr, "Ltex", function()
			local index = vim.g.ltex_index or 0

			local messages = {
				{
					lang = "en-US",
					index = 1,
					msg = "Setting language to `en-US`",
				},
				{
					lang = "pt-BR",
					index = 2,
					msg = "Setting language to `pt-BR`",
				},
				{
					lang = "none",
					index = 3,
					msg = "Ltex is now disabled",
				},
			}

			local new_index = (index % #messages) + 1 or 1

			local result = vim.tbl_filter(function(t) return t.index == new_index end, messages)[1]

			vim.notify(result.msg, vim.log.levels.INFO)

			local client = vim.lsp.get_clients({ name = "ltex_plus" })[1]

			if client and client.config.settings then
				client.config.settings.ltex.language = result.lang
				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			end

			vim.g.ltex_index = new_index
		end, {
			desc = "Toggle Ltex Language",
			nargs = "*",
		})
	end,
}
