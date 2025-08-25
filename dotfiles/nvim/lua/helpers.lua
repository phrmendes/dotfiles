local M = {}

--- Check if a file path is within a git repository.
--- Uses vim.fs.root to efficiently detect git repository presence.
--- @param file_path string: The file path to check.
--- @return boolean: True if the file is within a git repository, false otherwise.
local is_in_git_repository = function(file_path)
	local git_root = vim.fs.root(file_path, ".git")
	return git_root ~= nil
end

--- Get the path relative to git repository root.
--- Finds the git root directory and returns the file path relative to it.
--- If no git root is found, returns the original absolute path.
--- @param absolute_path string: The absolute file path to make relative.
--- @return string: The path relative to git root, or the original path if no git root found.
local get_git_relative_path = function(absolute_path)
	local git_root = vim.fs.root(absolute_path, ".git")
	if not git_root then return absolute_path end

	local normalized_path = vim.fs.normalize(absolute_path)
	local normalized_root = vim.fs.normalize(git_root)
	local root_prefix = normalized_root .. "/"

	if normalized_path:sub(1, #root_prefix) == root_prefix then return normalized_path:sub(#root_prefix + 1) end

	return absolute_path
end

--- Get the path relative to current working directory.
--- Converts an absolute file path to be relative to the current working directory.
--- Uses vim's filename modifier and normalizes the result.
--- @param absolute_path string: The absolute file path to make relative.
--- @return string: The path relative to current working directory, or the original path if cwd unavailable.
local get_cwd_relative_path = function(absolute_path)
	local current_directory = vim.uv.cwd()
	if not current_directory then return absolute_path end

	local relative_path = vim.fn.fnamemodify(absolute_path, ":~:.")
	return vim.fs.normalize(relative_path) or absolute_path
end

--- Exit visual mode in Neovim.
--- Sends an escape key sequence to exit the current visual selection mode.
--- Uses proper termcode replacement for cross-platform compatibility.
--- @return nil
local exit_visual_mode = function()
	local escape_sequence = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(escape_sequence, "n", false)
end

local format_current_line_reference = function(file_path)
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor_position[1]
	return string.format("%s:%d", file_path, current_line)
end

local format_visual_selection_reference = function(file_path)
	local current_buffer = vim.api.nvim_get_current_buf()
	local start_position = vim.api.nvim_buf_get_mark(current_buffer, "<")
	local end_position = vim.api.nvim_buf_get_mark(current_buffer, ">")
	local start_line = start_position[1]
	local end_line = end_position[1]

	local reference = start_line == end_line and string.format("%s:%d", file_path, start_line)
		or string.format("%s:%d-%d", file_path, start_line, end_line)

	exit_visual_mode()
	return reference
end

local add_line_numbers_to_reference = function(file_path, is_visual_mode)
	if is_visual_mode then
		return format_visual_selection_reference(file_path)
	else
		return format_current_line_reference(file_path)
	end
end

local get_path = function(force_cwd)
	local current_buffer = vim.api.nvim_get_current_buf()
	local absolute_path = vim.api.nvim_buf_get_name(current_buffer)

	if absolute_path == "" then return nil end

	if not force_cwd and is_in_git_repository(absolute_path) then
		return get_git_relative_path(absolute_path)
	else
		return get_cwd_relative_path(absolute_path)
	end
end

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
	local file_path = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")

	local word_set = {}

	if vim.uv.fs_stat(file_path) then
		local content = vim.fn.readfile(file_path)

		vim
			.iter(content)
			:filter(function(line) return line:match("^%s*(.-)%s*$") ~= "" end) -- remove empty lines
			:map(function(line) return line:match("^%s*(.-)%s*$") end) -- trim whitespace
			:each(function(trimmed_word) word_set[trimmed_word] = true end)
	end

	word_set[word:match("^%s*(.-)%s*$")] = true

	local unique_words = vim.iter(word_set):map(function(w, _) return w end):totable()

	table.sort(unique_words)

	vim.fn.writefile(unique_words, file_path)

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

--- Copy file reference with optional line numbers to register.
--- Creates a reference string containing the file path and optionally line numbers,
--- then copies it to the system clipboard (+). Useful for sharing code locations.
--- Automatically detects git repository and uses appropriate path (git root or cwd).
--- In visual mode, always includes line numbers regardless of include_lines parameter.
--- @param include_lines boolean|nil: If not false, includes line number information. Defaults to true. Ignored in visual mode.
--- @param force_cwd boolean|nil: If true, forces use of cwd even if in a git repository. Defaults to false.
--- @return nil
M.copy_file_reference = function(include_lines, force_cwd)
	local file_path = get_path(force_cwd)

	if not file_path then
		vim.notify("No file to copy", vim.log.levels.WARN)
		return
	end

	local current_mode = vim.api.nvim_get_mode().mode
	local is_visual_mode = current_mode:match("^[vV\022]")
	local reference = file_path

	if is_visual_mode or include_lines ~= false then
		reference = add_line_numbers_to_reference(file_path, is_visual_mode)
	end

	vim.fn.setreg("+", reference)
	vim.notify("Copied: " .. reference)
end

return M
