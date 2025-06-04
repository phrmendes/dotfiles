local M = {
	visits = {},
	files = {},
	pick = {},
}

--- Open files from mini.files in split windows.
--- @param direction "vertical"|"horizontal" Direction of the split
--- @param close_on_file boolean Close mini.files when opening the file
M.files.split = function(direction, close_on_file)
	return function()
		local new_win
		local win = MiniFiles.get_explorer_state().target_window

		if win ~= nil then
			vim.api.nvim_win_call(win, function()
				vim.cmd("belowright " .. direction .. " split")
				new_win = vim.api.nvim_get_current_win()
			end)

			MiniFiles.set_target_window(new_win)
			MiniFiles.go_in({ close_on_file = close_on_file })
		end
	end
end

--- Open files in mini.files
M.files.open = function()
	if not MiniFiles.close() then
		local path = vim.fn.expand("%:p:h")
		if vim.uv.fs_stat(path) then
			MiniFiles.open(path, true)
			return
		end
		MiniFiles.open(nil, true)
	end
end

--- Open the mini.pick buffer picker with a custom mapping for wiping out buffers
M.pick.buffers = function()
	MiniPick.builtin.buffers(nil, {
		mappings = {
			wipeout = {
				char = "<c-d>",
				func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
			},
		},
	})
end

--- Open the mini.pick grep picker with a custom mapping for grepping the word under the cursor or in visual selection
M.pick.grep_word = function()
	local mode = vim.api.nvim_get_mode().mode

	if mode == "n" then
		MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
		return
	end

	local v_start = vim.fn.getpos(".")
	local v_end = vim.fn.getpos("v")
	local region = table.concat(vim.fn.getregion(v_start, v_end)):gsub("\t", "")

	MiniPick.builtin.grep({ pattern = region })
end

--- Add mini.visits label using `vim.ui.input`
M.visits.add_label = function()
	vim.ui.input({ prompt = "Label: " }, function(input)
		if input == "" or input == nil then
			vim.notify("Label cannot be empty", vim.log.levels.ERROR)
			return
		end

		MiniVisits.add_label(input)
	end)
end

--- Remove mini.visits label using `vim.ui.select`
M.visits.remove_label = function()
	vim.ui.select(MiniVisits.list_labels(), { prompt = "Select label: " }, function(input)
		if input == "" or input == nil then
			vim.notify("Label cannot be empty", vim.log.levels.ERROR)
			return
		end

		MiniVisits.remove_label(input)
	end)
end

return M
