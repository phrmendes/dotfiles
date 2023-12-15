local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = augroup,
	callback = function()
		local server = vim.lsp.get_active_clients({ name = "yamlls", bufnr = 0 })

		for _, client in ipairs(server) do
			vim.lsp.stop_client(client.id)
		end
	end,
})
