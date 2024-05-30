local autocmd = vim.api.nvim_create_autocmd
local augroups = require("utils").augroups

autocmd("TermOpen", {
	group = augroups.term,
	pattern = "*",
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.cmd([[startinsert]])
	end,
})

autocmd("TermClose", {
	group = augroups.term,
	pattern = { "*" },
	callback = function()
		vim.wo.number = true
		vim.wo.relativenumber = true
	end,
})

autocmd("BufEnter", {
	pattern = { "*.pdf", "*.png", "*.jpg", "*.jpeg" },
	group = augroups.filetype,
	callback = function()
		local filename = vim.api.nvim_buf_get_name(0)
		filename = vim.fn.shellescape(filename)

		require("utils").open(filename)

		vim.cmd.redraw()
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroups.fs,
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

autocmd("LspAttach", {
	group = augroups.lsp.attach,
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client.server_capabilities.documentHighlightProvider then
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

autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
	group = augroups.filetype,
	pattern = { "*.md", "*.qmd" },
	callback = function()
		vim.cmd([[set syntax=markdown.pandoc]])
	end,
})

autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
	group = augroups.filetype,
	pattern = "*.http",
	callback = function()
		vim.cmd([[set filetype=http]])
	end,
})

autocmd("User", {
	pattern = "MiniGitCommandSplit",
	group = augroups.git,
	callback = function(event)
		if event.data.git_subcommand ~= "blame" then
			return
		end

		-- align blame output with source
		local win_src = event.data.win_source
		vim.wo.wrap = false
		vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
		vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

		-- bind both windows so that they scroll together
		vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
	end,
})
