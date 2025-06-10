local M = {}

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

--- Returns all subdirectories under a path. The path is absolute.
--- @param path string: The path to search for subdirectories.
--- @return string[]: A list of subdirectory paths.
M.get_subdirectories = function(path)
	return vim
		.iter(vim.fs.dir(path))
		:filter(function(_, type) return type == "directory" end)
		:map(function(name, _) return vim.fs.joinpath(path, name) end)
		:totable()
end

--- Load all plugins in a directory.
--- @param path string: The path to the plugins directory.
--- @return nil
M.load_plugins = function(path)
	if not vim.uv.fs_stat(path) then
		vim.notify("Plugins directory does not exist: " .. path, vim.log.levels.ERROR)
		return
	end

	vim
		.iter(vim.fs.dir(path))
		:map(function(name, type)
			if type == "file" then return name:sub(1, -5) end
			return name
		end)
		:filter(function(name, _) return name ~= "init" end)
		:each(function(name, _)
			local rel = path:match(".-/plugins/(.+)")
			local plugin

			if rel then
				plugin = "plugins." .. rel:gsub("/", ".") .. "." .. name
			else
				plugin = "plugins." .. name
			end

			require(plugin)
		end)
end

return M
