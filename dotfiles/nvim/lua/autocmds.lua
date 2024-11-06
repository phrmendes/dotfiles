local autocmd = vim.api.nvim_create_autocmd
local augroups = require("utils").augroups

autocmd("LspAttach", {
	desc = "LSP options and keymaps",
	group = augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		if client then
			require("keymaps").lsp(client, event.buf)
			require("commands").lsp(client, event.buf)

			if client.supports_method("textDocument/codeLens") then
				autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
					buffer = event.buf,
					callback = function(ev)
						vim.lsp.codelens.refresh({ bufnr = ev.buf })
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

autocmd("BufWritePre", {
	group = augroups.lsp.lint_format,
	callback = function(ev)
		vim.lsp.buf.format({
			async = true,
			bufnr = ev.buf,
			filter = function(client)
				return client.name == "efm"
			end,
		})
	end,
})

autocmd("User", {
	desc = "Set border for mini.files window",
	group = augroups.mini,
	pattern = "MiniFilesWindowOpen",
	callback = function(event)
		local win_id = event.data.win_id

		vim.api.nvim_win_set_config(win_id, { border = require("utils").borders.border })
	end,
})

autocmd("User", {
	desc = "Config mini.files keybindings",
	group = augroups.mini,
	pattern = "MiniFilesBufferCreate",
	callback = function(event)
		require("keymaps").mini.files(event)
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroups.yank,
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd("FileType", {
	desc = "Close with <q>",
	group = augroups.filetype,
	pattern = { "dap-float", "diff", "git", "help", "man", "qf", "query", "scratch", "undotree" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
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
