local augroup = require("utils").augroup
local open = require("utils").open

local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
	group = augroup,
	pattern = { "*" },
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.api.nvim_command("startinsert")
	end,
})

autocmd("TermClose", {
	group = augroup,
	pattern = { "*" },
	callback = function()
		vim.wo.number = true
		vim.wo.relativenumber = true
	end,
})

autocmd("BufEnter", {
	pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg" },
	group = augroup,
	callback = function()
		local filename = vim.api.nvim_buf_get_name(0)
		filename = vim.fn.shellescape(filename)

		open(filename)

		vim.cmd.redraw()

		vim.defer_fn(function()
			vim.cmd.bdelete({ bang = true })
		end, 500)
	end,
})

autocmd("LspAttach", {
	group = augroup,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
