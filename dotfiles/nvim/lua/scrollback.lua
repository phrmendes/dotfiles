--- This function is used to create a terminal buffer with a specific scrollback line number.
--- @INPUT_LINE_NUMBER: str
--- @return nil
return function(INPUT_LINE_NUMBER)
	vim.opt_local.encoding = "utf-8"
	vim.opt_local.scrolloff = 0
	vim.opt_local.compatible = false
	vim.opt_local.number = false
	vim.opt_local.termguicolors = true
	vim.opt_local.showmode = false
	vim.opt_local.ruler = false
	vim.opt_local.signcolumn = "no"
	vim.opt_local.showtabline = 0
	vim.opt_local.laststatus = 0
	vim.opt_local.cmdheight = 0
	vim.opt_local.showcmd = false
	vim.opt_local.scrollback = 100000

	local buffer = vim.api.nvim_create_buf(true, false)
	local terminal = vim.api.nvim_open_term(buffer, {})

	vim.api.nvim_buf_set_keymap(buffer, "v", "q", "y<cmd>qa!<cr>", {})
	vim.api.nvim_buf_set_keymap(buffer, "n", "q", "<cmd>qa!<cr>", {})

	local group = vim.api.nvim_create_augroup("KittyScrollback", { clear = true })

	local set_cursor = function()
		local max_line_nr = vim.api.nvim_buf_line_count(buffer)
		local input_line_number = tonumber(INPUT_LINE_NUMBER)

		if not input_line_number then
			vim.notify("Scrollback: invalid line number", vim.log.levels.ERROR)
			return
		end

		local input_line_nr = math.max(1, math.min(input_line_number, max_line_nr))

		-- it seems that both the view (view.topline) and the cursor (nvim_win_set_cursor) must be set
		-- for scrolling and cursor positioning to work reliably with terminal buffers.
		vim.fn.winrestview({ topline = input_line_nr })
		vim.api.nvim_win_set_cursor(0, { input_line_nr, 0 })
	end

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		buffer = buffer,
		callback = function()
			local mode = vim.fn.mode()

			if mode == "t" then
				vim.cmd.stopinsert()
				vim.schedule(set_cursor)
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		pattern = "*",
		once = true,
		callback = function(ev)
			local current_win = vim.fn.win_getid()

			-- instead of sending lines individually, concatenate them
			local main_lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -2, false)
			local content = table.concat(main_lines, "\r\n")
			vim.api.nvim_chan_send(terminal, content .. "\r\n")

			-- process the last line separately (without trailing \r\n)
			local last_line = vim.api.nvim_buf_get_lines(ev.buf, -2, -1, false)[1]
			if last_line then vim.api.nvim_chan_send(terminal, last_line) end
			vim.api.nvim_win_set_buf(current_win, buffer)
			vim.api.nvim_buf_delete(ev.buf, { force = true })

			-- use vim.defer_fn to make sure the terminal has time to process the content and the buffer is ready
			vim.defer_fn(set_cursor, 10)
		end,
	})
end
