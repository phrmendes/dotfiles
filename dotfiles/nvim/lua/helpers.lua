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

--- Copy file reference with optional line numbers to register.
--- @param include_lines boolean|nil If true, includes line number information. Defaults to true. Ignored in visual mode.
--- @param absolute boolean|nil If true, returns absolute path. Defaults to false.
--- @return nil
M.copy_file_reference = function(include_lines, absolute)
	local current_buffer = vim.api.nvim_get_current_buf()
	local absolute_path = vim.api.nvim_buf_get_name(current_buffer)

	if absolute_path == "" then
		vim.notify("No file to copy", vim.log.levels.WARN)
		return
	end

	local file_path

	if absolute then
		file_path = absolute_path
	else
		local git_root = vim.fs.root(absolute_path, ".git")

		if git_root then
			file_path = vim.fn.fnamemodify(absolute_path, ":s?" .. vim.pesc(git_root) .. "/??")
		else
			file_path = vim.fn.fnamemodify(absolute_path, ":~:.")
		end
	end

	local current_mode = vim.api.nvim_get_mode().mode
	local is_visual_mode = current_mode:match("^[vV\022]")

	local reference

	if is_visual_mode or include_lines ~= false then
		if is_visual_mode then
			local start_pos = vim.fn.getpos("v")
			local end_pos = vim.fn.getpos(".")

			local escape_sequence = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

			vim.api.nvim_feedkeys(escape_sequence, "n", false)

			local start_line = math.min(start_pos[2], end_pos[2])
			local end_line = math.max(start_pos[2], end_pos[2])

			local is_single_line = start_line == end_line
			local single_line_ref = string.format("%s:%d", file_path, start_line)
			local range_ref = string.format("%s:%d-%d", file_path, start_line, end_line)

			reference = is_single_line and single_line_ref or range_ref
		else
			local cursor_position = vim.api.nvim_win_get_cursor(0)
			local current_line = cursor_position[1]

			reference = string.format("%s:%d", file_path, current_line)
		end
	else
		reference = file_path
	end

	vim.fn.setreg("+", reference)
	vim.notify("Copied: " .. reference)
end

return M
