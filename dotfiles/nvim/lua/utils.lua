local M = {}

M.border = "rounded"

--- Toggle emphasis in visual mode.
--- @param key string: The key to toggle.
--- @return string: The keybinding.
M.toggle_emphasis = function(key)
	return [[<esc>gv<cmd>lua require("markdown.inline").toggle_emphasis_visual("]] .. key .. [[")<cr>]]
end

--- Get the words from a dictionary file.
--- @param lang string: The language of the dictionary.
--- @return string[]: A list of words.
M.get_dictionary_words = function(lang)
	local file = vim.env.HOME .. "/Documents/notes/dictionaries/" .. lang .. ".add"
	local words = {}

	if vim.uv.fs_stat(file) == nil then
		vim.notify("File does not exist: " .. file, vim.log.levels.ERROR)
		return {}
	end

	for word in io.lines(file) do
		table.insert(words, word)
	end

	return words
end

--- Add a word to a dictionary file.
--- @param lang string: The language of the dictionary.
--- @param word string: The word to add.
--- @return string[]: A list of unique words.
M.add_word_to_dictionary = function(lang, word)
	local file = vim.env.HOME .. "/Documents/notes/dictionaries/" .. lang .. ".add"
	local words = {}
	local unique_words = {}

	local f = io.open(file, "r")

	if f then
		for line in f:lines() do
			words[line] = true
		end

		f:close()
	end

	words[word] = true

	f = io.open(file, "w")

	if f then
		for w in pairs(words) do
			f:write(w .. "\n")
			table.insert(unique_words, w)
		end

		f:close()
	end

	return unique_words
end

--- Paste the contents of the system clipboard.
--- @return table: A table containing clipboard lines and register type.
M.paste = function()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

--- Open files from mini.files in split windows.
--- @param direction "vertical"|"horizontal" Direction of the split
--- @param close_on_file boolean Close mini.files when opening the file
M.mini_files_split = function(direction, close_on_file)
	return function()
		local new_win
		local files = require("mini.files")
		local win = files.get_explorer_state().target_window

		if win ~= nil then
			vim.api.nvim_win_call(win, function()
				vim.cmd("belowright " .. direction .. " split")
				new_win = vim.api.nvim_get_current_win()
			end)

			files.set_target_window(new_win)
			files.go_in({ close_on_file = close_on_file })
		end
	end
end

--- Open files in mini.files
M.mini_files_open = function()
	if not require("mini.files").close() then
		local path = vim.fn.expand("%:p:h")
		if vim.uv.fs_stat(path) then
			require("mini.files").open(path, true)
			return
		end
		require("mini.files").open(nil, true)
	end
end

--- Open the mini.pick buffer picker with a custom mapping for wiping out buffers
M.mini_pick_buffers = function()
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
M.mini_pick_grep_word = function()
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
M.mini_visits_add_label = function()
	vim.ui.input({ prompt = "Label: " }, function(input)
		if input == "" or input == nil then
			vim.notify("Label cannot be empty", vim.log.levels.ERROR)
			return
		end

		MiniVisits.add_label(input)
	end)
end

--- Remove mini.visits label using `vim.ui.select`
M.mini_visits_remove_label = function()
	vim.ui.select(MiniVisits.list_labels(), { prompt = "Select label: " }, function(input)
		if input == "" or input == nil then
			vim.notify("Label cannot be empty", vim.log.levels.ERROR)
			return
		end

		MiniVisits.remove_label(input)
	end)
end

return M
