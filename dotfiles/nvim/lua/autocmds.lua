local autocmd = vim.api.nvim_create_autocmd
local augroups = require("utils").augroups

autocmd("TermOpen", {
	group = augroups.term,
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.cmd([[startinsert]])
	end,
})

autocmd("TextYankPost", {
	group = augroups.yank,
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

autocmd("TermClose", {
	group = augroups.term,
	callback = function()
		vim.wo.number = true
		vim.wo.relativenumber = true
	end,
})

autocmd("BufEnter", {
	pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg" },
	group = augroups.filetype,
	callback = function(event)
		local filename = vim.api.nvim_buf_get_name(event.buf)
		filename = vim.fn.shellescape(filename)

		require("utils").open(filename)

		vim.cmd.redraw()
	end,
})

autocmd("LspAttach", {
	group = augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
			if client.supports_method("textDocument/inlayHint") then
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

			if client.supports_method("textDocument/codeLens") then
				autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
					buffer = event.buf,
					callback = function()
						vim.lsp.codelens.refresh({ bufnr = event.buf })
					end,
				})
			end

			if client.supports_method("textDocument/documentHighlight") then
				autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = augroups.lsp.highlight,
					callback = vim.lsp.buf.document_highlight,
				})

				autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = augroups.lsp.highlight,
					callback = vim.lsp.buf.clear_references,
				})

				autocmd("LspDetach", {
					group = augroups.lsp.detach,
					callback = function(ev)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "UserLspHighlight", buffer = ev.buf })
					end,
				})
			end
		end
	end,
})

autocmd("BufWritePost", {
	group = augroups.lsp.format,
	callback = function(event)
		local efm = vim.lsp.get_clients({ name = "efm", bufnr = event.buf })

		if vim.tbl_isempty(efm) then
			return
		end

		vim.lsp.buf.format({ name = "efm" })
	end,
})

autocmd("FileType", {
	group = augroups.filetype,
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

autocmd({ "FileType" }, {
	group = augroups.filetype,
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

autocmd("User", {
	pattern = "MiniFilesWindowOpen",
	group = augroups.mini,
	callback = function(event)
		local win_id = event.data.win_id

		vim.api.nvim_win_set_config(win_id, { border = "rounded" })
	end,
})
