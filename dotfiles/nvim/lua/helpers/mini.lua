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

--- Toggle mini.files
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

--- Toggle dotfiles in mini.files
M.files.toggle_dotfiles = function()
	local filter_show = function() return true end

	local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

	vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles

	MiniFiles.refresh({
		content = { filter = vim.g.mini_show_dotfiles and filter_show or filter_hide },
	})
end

--- Open file from mini.files
M.files.open_file = function()
	local fs_entry = MiniFiles.get_fs_entry()

	if not fs_entry then
		vim.notify("No file selected", vim.log.levels.ERROR, { title = "mini.nvim" })
		return
	end

	vim.schedule(function()
		vim.notify("Opening " .. fs_entry.name, vim.log.levels.INFO, { title = "mini.nvim" })
		vim.ui.open(fs_entry.path)
	end)
end

--- Set current workdir in mini.files
M.files.set_cwd = function()
	local current_entry_path = MiniFiles.get_fs_entry().path
	local current_directory = vim.fs.dirname(current_entry_path)
	if current_directory ~= nil then vim.fn.chdir(current_directory) end
end

--- Search limited to focused directory in mini.files
M.files.grug_far_replace = function()
	local grug_far = require("grug-far")

	local cur_entry_path = MiniFiles.get_fs_entry().path
	local prefills = { paths = vim.fs.dirname(cur_entry_path) }

	if not grug_far.has_instance("explorer") then
		grug_far.open({
			instanceName = "explorer",
			prefills = prefills,
			staticTitle = "Find and Replace from Explorer",
		})
	else
		grug_far.get_instance("explorer"):open()
		grug_far.get_instance("explorer"):update_input_values(prefills, false)
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
