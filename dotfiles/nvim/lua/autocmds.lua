local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local clear = vim.api.nvim_clear_autocmds

local augroups = {
	line_numbers = augroup("UserLineNumbers", {}),
	filetype = augroup("UserFileType", {}),
	yank = augroup("UserYank", {}),
	windows = augroup("UserWindows", {}),
	lsp = {
		attach = augroup("UserLspAttach", {}),
		detach = augroup("UserLspDetach", {}),
		highlight = augroup("UserLspHighlight", {}),
	},
}

autocmd("LspAttach", {
	desc = "LSP options",
	group = augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if not client then return end

		require("keymaps.lsp")(client, event.buf)

		if client:supports_method("textDocument/codeLens", event.buf) then
			autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = event.buf,
				callback = function(ev) vim.lsp.codelens.refresh({ bufnr = ev.buf }) end,
			})
		end

		if client:supports_method("textDocument/documentHighlight", event.buf) then
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
				buffer = event.buf,
				callback = function(ev)
					vim.lsp.buf.clear_references()
					clear({ group = "UserLspHighlight", buffer = ev.buf })
				end,
			})
		end
	end,
})

autocmd("WinEnter", {
	desc = "Automatically close Vim if the quickfix window is the only one open",
	group = augroups.windows,
	callback = function()
		if vim.fn.winnr("$") == 1 and vim.fn.win_gettype() == "quickfix" then vim.cmd.q() end
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroups.yank,
	callback = function() vim.hl.on_yank() end,
})

autocmd("FileType", {
	desc = "Close with <q>",
	group = augroups.filetype,
	pattern = { "dap-float", "dap-repl", "dap-view", "dap-view-term", "diff", "git", "help", "man", "qf", "query" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
	end,
})

autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	desc = "Enable relative line numbers in normal mode",
	group = augroups.line_numbers,
	pattern = "*",
	command = "if &nu && mode() != 'i' | set rnu | endif",
})

autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	desc = "Disable relative line numbers in insert mode",
	group = augroups.line_numbers,
	pattern = "*",
	command = "if &nu | set nornu | endif",
})
