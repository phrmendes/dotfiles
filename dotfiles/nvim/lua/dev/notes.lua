--- @module 'notes'
local pick = require("mini.pick")

local M = {}
local config = {}

--- Normalizes a word by converting it to lowercase, replacing accented characters with their unaccented equivalents,
--- and replacing spaces and non-word characters with underscores.
--- @param word string: The word to normalize.
--- @return string: The normalized word.
local normalize_string = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
			:gsub("[ç]", "c")
	end)

	local string, _ = normalized_word:gsub("[%s%W]", "_")

	return string
end

--- Creates an array of tags from a string.
--- @param str string: The string to split.
--- @param sep string: The separator to use for splitting the string.
--- @return string: A string with tags separated by commas.
local function create_tags(str, sep)
	local tags = {}

	for i in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(tags, "#" .. i)
	end

	return table.concat(tags, ", ")
end

--- Generates an array of random characters or numbers.
--- @param n number: The length of the array.
--- @param char? boolean: If true, generates random uppercase letters; otherwise, generates random numbers.
--- @return (integer | string)[]: An array of random characters or numbers.
local generate_random_array = function(n, char)
	local array = {}
	local upper, lower

	if char then
		upper, lower = 65, 90 -- ASCII values for 'A' to 'Z'
	else
		upper, lower = 0, 9
	end

	while #array < n do
		if char then
			table.insert(array, string.char(math.random(upper, lower)))
		else
			table.insert(array, math.random(upper, lower))
		end
	end

	return array
end

--- Search for notes
--- @param path string: Path to search in
--- @return nil
M.search = function(path)
	path = path or config.path

	pick.builtin.cli({
		command = { "fd", "-t", "f", "-e", "md" },
	}, {
		source = {
			name = "Notes",
			cwd = path,
			show = function(buf_id, items, query)
				require("mini.pick").default_show(buf_id, items, query, { show_icons = true })
			end,
		},
	})
end

--- Live grep in notes
--- @param path string: Path to grep in
--- @return nil
M.grep_live = function(path)
	path = path or config.path

	pick.builtin.grep_live({
		globs = { "*.md" },
	}, {
		source = {
			name = "Search in notes",
			cwd = path,
			show = function(buf_id, items, query)
				pick.default_show(buf_id, items, query, { show_icons = true })
			end,
		},
	})
end

--- Create a new note
--- @param path string: Path to create the note in
--- @return nil
M.new = function(path)
	path = path or config.path

	local title = vim.fn.input("Title: ")

	if title == "" then
		vim.notify("Note not created: title can't be empty", vim.log.levels.ERROR)
		return
	end

	local tags = create_tags(vim.fn.input("Tags (separated by comma): "), ",")
	local normalized_title = normalize_string(title)
	local id = table.concat(generate_random_array(4, true))
	local date = os.date("%Y%m%d")

	local file_path = path .. "/" .. date .. id .. "-" .. normalized_title .. ".md"

	vim.cmd("vnew " .. file_path)

	local buf = vim.api.nvim_get_current_buf()

	local content = { "# " .. title, "" }

	if tags ~= "" then
		content = vim.list_extend(content, { "**Tags:** " .. tags, "" })
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
end

--- Setup notes plugin
--- @param opts table: Options for setup
--- @return nil
M.setup = function(opts)
	opts = opts or {}
	config.path = opts.path or vim.env.HOME .. "/Documents/notes"
end

return M
