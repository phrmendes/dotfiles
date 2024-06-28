local autocmd = vim.api.nvim_create_autocmd
local augroups = require("utils").augroups

autocmd("TermOpen", {
	desc = "Disable numbers in terminal",
	group = augroups.term,
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.cmd([[startinsert]])
	end,
})

autocmd("TermClose", {
	desc = "Enable numbers when terminal is closed",
	group = augroups.term,
	callback = function()
		vim.wo.number = true
		vim.wo.relativenumber = true
	end,
})

autocmd("BufEnter", {
	desc = "Open files with system default",
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
	desc = "Enable code lens and document highlights",
	group = augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client then
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
	desc = "Format on save with efm-langserver",
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
	desc = "Close with <q>",
	group = augroups.filetype,
	pattern = {
		"git",
		"help",
		"man",
		"qf",
		"query",
		"scratch",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = event.buf })
	end,
})

autocmd("FileType", {
	desc = "Disable	conceal for JSON files",
	group = augroups.filetype,
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

autocmd("User", {
	desc = "Set border for mini files window",
	group = augroups.mini,
	pattern = "MiniFilesWindowOpen",
	callback = function(event)
		local win_id = event.data.win_id

		vim.api.nvim_win_set_config(win_id, { border = "rounded" })
	end,
})
