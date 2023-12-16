local augroup = require("utils").augroup

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "TermOpen" }, {
	group = augroup,
	pattern = { "*" },
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.api.nvim_command("startinsert")
	end,
})

autocmd({ "TermClose" }, {
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

		if vim.fn.has("mac") == 1 then
			vim.cmd["!"]({ "open", filename })
		else
			vim.cmd["!"]({ "xdg-open", filename })
		end

		vim.cmd.redraw()

		vim.defer_fn(function()
			vim.cmd.bdelete({ bang = true })
		end, 1000)
	end,
})
