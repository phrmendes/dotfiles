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

return M
