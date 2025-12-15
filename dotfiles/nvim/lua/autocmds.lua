local augroups = {
	line_numbers = vim.api.nvim_create_augroup("UserLineNumbers", {}),
	filetype = vim.api.nvim_create_augroup("UserFileType", {}),
	yank = vim.api.nvim_create_augroup("UserYank", {}),
	windows = vim.api.nvim_create_augroup("UserWindows", {}),
	treesitter = vim.api.nvim_create_augroup("UserTreesitter", {}),
	lsp = {
		attach = vim.api.nvim_create_augroup("UserLspAttach", {}),
		detach = vim.api.nvim_create_augroup("UserLspDetach", {}),
		highlight = vim.api.nvim_create_augroup("UserLspHighlight", {}),
	},
}

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP options",
	group = augroups.lsp.attach,
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		require("keymaps.lsp")(client, event.buf)

		vim.bo[event.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
			vim.lsp.inline_completion.enable(true, { bufnr = event.buf })

			vim.api.nvim_buf_create_user_command(
				event.buf,
				"LspCopilotDisable",
				function() vim.lsp.inline_completion.enable(false, { bufnr = event.buf }) end,
				{ desc = "Disable LSP inline completions for the current buffer" }
			)
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = event.buf,
				callback = function(ev) vim.lsp.codelens.refresh({ bufnr = ev.buf }) end,
			})
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = augroups.lsp.highlight,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = augroups.lsp.highlight,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = augroups.lsp.detach,
				buffer = event.buf,
				callback = function(ev)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "UserLspHighlight", buffer = ev.buf })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroups.treesitter,
	callback = function(event)
		local language = vim.treesitter.language.get_lang(event.match) or event.match

		if not vim.treesitter.language.add(language) then return end

		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.treesitter.start(event.buf, language)
		vim.bo[event.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	desc = "Automatically close Vim if the quickfix window is the only one open",
	group = augroups.windows,
	callback = function()
		if vim.fn.winnr("$") == 1 and vim.fn.win_gettype() == "quickfix" then vim.cmd.q() end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = augroups.yank,
	callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close with <q>",
	group = augroups.filetype,
	pattern = { "dap-float", "dap-repl", "dap-view", "dap-view-term", "diff", "git", "help", "man", "qf", "query" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = event.buf })
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	desc = "Enable relative line numbers in normal mode",
	group = augroups.line_numbers,
	pattern = "*",
	command = "if &nu && mode() != 'i' | set rnu | endif",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	desc = "Disable relative line numbers in insert mode",
	group = augroups.line_numbers,
	pattern = "*",
	command = "if &nu | set nornu | endif",
})

vim.api.nvim_create_autocmd("VimResized", {
	desc = "Equalize window sizes after resizing Vim",
	group = augroups.windows,
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "No auto continue comments on new lines",
	group = augroups.filetype,
	pattern = "*",
	callback = function() vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" } end,
})
