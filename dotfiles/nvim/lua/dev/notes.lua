--- @module 'notes'
local M = {}
local config = {}

--- Normalizes a word by converting it to lowercase, replacing accented characters with their unaccented equivalents,
--- and replacing spaces and non-word characters with underscores.
--- @param word string: The word to normalize.
--- @return string: The normalized word.
local normalize = function(word)
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

--- Search for notes
--- @param path string: Path to search in
M.search = function(path)
	path = path or config.path

	require("mini.pick").builtin.cli({
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
M.grep_live = function(path)
	path = path or config.path

	require("mini.pick").builtin.grep_live({
		globs = { "*.md" },
	}, {
		source = {
			name = "Search in notes",
			cwd = path,
			show = function(buf_id, items, query)
				require("mini.pick").default_show(buf_id, items, query, { show_icons = true })
			end,
		},
	})
end

--- Create a new note
--- @param path string: Path to create the note in
M.new = function(path)
	path = path or config.path

	local input = vim.fn.input("Title: ")

	if input ~= "" then
		local normalized_input = normalize(input)
		local file_path = path .. normalized_input .. ".md"
		local today = os.date("%d/%m/%Y")

		vim.cmd("vnew " .. file_path)

		local buf = vim.api.nvim_get_current_buf()

		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
			"---",
			"date: " .. today,
			"---",
			"",
			"# " .. input,
			"",
		})
	end
end

--- Setup notes plugin
--- @param opts table: Options for setup
M.setup = function(opts)
	opts = opts or {}
	config.path = opts.path or vim.env.HOME .. "/Documents/notes"
end

return M
