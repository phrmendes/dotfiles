local M = {}

--- Toggle emphasis in visual mode.
--- @param key string The key to toggle.
--- @return string The keybinding.
M.toggle_emphasis = function(key)
	return [[<esc>gv<cmd>lua require("markdown.inline").toggle_emphasis_visual("]] .. key .. [[")<cr>]]
end

--- Get the words from a dictionary file.
--- @param lang string The language of the dictionary.
--- @return string[]: A list of words.
M.get_dictionary_words = function(lang)
	local file = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")
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
--- @param lang string The language of the dictionary.
--- @param word string The word to add.
--- @return string[]: A list of unique words.
M.add_word_to_dictionary = function(lang, word)
	local file = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")

	local word_set = {}

	if vim.uv.fs_stat(file) then
		local content = vim.fn.readfile(file)

		vim
			.iter(content)
			:filter(function(line) return line:match("^%s*(.-)%s*$") ~= "" end) -- remove empty lines
			:map(function(line) return line:match("^%s*(.-)%s*$") end) -- trim whitespace
			:each(function(trimmed_word) word_set[trimmed_word] = true end)
	end

	word_set[word:match("^%s*(.-)%s*$")] = true

	local unique_words = vim.iter(word_set):map(function(w, _) return w end):totable()

	table.sort(unique_words)

	vim.fn.writefile(unique_words, file)

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

--- Returns all subdirectories under a path. The path is absolute.
--- @param path string The path to search for subdirectories.
--- @return string[]: A list of subdirectory paths.
M.get_subdirectories = function(path)
	return vim
		.iter(vim.fs.dir(path))
		:filter(function(_, type) return type == "directory" end)
		:map(function(name, _) return vim.fs.joinpath(path, name) end)
		:totable()
end

return M
