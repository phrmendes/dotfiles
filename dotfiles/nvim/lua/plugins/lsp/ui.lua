local autocmd = vim.api.nvim_create_autocmd

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

autocmd("LspAttach", {
	group = require("utils").augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
			if client.server_capabilities.documentHighlightProvider then
				autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end

			if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
				autocmd("InsertEnter", {
					buffer = event.buf,
					callback = function()
						vim.lsp.inlay_hint.enable(true)
					end,
				})

				autocmd("InsertLeave", {
					buffer = event.buf,
					callback = function()
						vim.lsp.inlay_hint.enable(false)
					end,
				})
			end
		end
	end,
})
