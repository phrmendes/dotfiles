local M = {}

M.borders = {
	border = "rounded",
	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

M.toggle_emphasis = function(key)
	return [[<esc>gv<cmd>lua require("markdown.inline").toggle_emphasis_visual("]] .. key .. [[")<cr>]]
end

M.get_dictionary_words = function(lang)
	local file = vim.env.HOME .. "/Documents/notes/dictionaries/" .. lang .. ".add"
	local words = {}

	if vim.uv.fs_stat(file) == nil then
		vim.notify("File does not exist: " .. file)
		return
	end

	for word in io.lines(file) do
		table.insert(words, word)
	end

	return words
end

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

M.paste = function()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end

return M
