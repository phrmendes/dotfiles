local augroup = vim.api.nvim_create_augroup

local M = {}

M.mini = {}
M.mini.notify = {}
M.mini.pick = {}
M.mini.git = {}

M.augroups = {
	filetype = augroup("UserFileType", {}),
	mini = augroup("UserMini", {}),
	yank = augroup("UserYank", {}),
	windows = augroup("UserWindows", {}),
	lsp = {
		attach = augroup("UserLspAttach", {}),
		detach = augroup("UserLspDetach", {}),
		efm = augroup("UserLspEfm", {}),
		highlight = augroup("UserLspHighlight", {}),
	},
}

M.match_pattern = function(string, pattern)
	if string:match(pattern) then return true end

	return false
end

M.normalize = function(word)
	local normalized_word = word:lower():gsub(
		"[%z\1-\127\194-\244][\128-\191]*",
		function(c)
			return c:gsub("[áàâ]", "a")
				:gsub("[éèê]", "e")
				:gsub("[íìî]", "i")
				:gsub("[óòô]", "o")
				:gsub("[úùû]", "u")
				:gsub("[ç]", "c")
		end
	)

	return normalized_word:gsub("[%s%W]", "_")
end

M.borders = {
	border = "rounded",
	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

M.config_diagnostics = function(signs, config)
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	vim.diagnostic.config(config)
end

M.config_lsp_server = function(opts)
	local config = opts.config or {}
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	config.capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	config.handlers = {
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, M.borders),
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, M.borders),
	}

	require("lspconfig")[opts.server].setup(config)
end

M.display_callback = function(variable)
	if #variable.value > 15 then return " " .. string.sub(variable.value, 1, 15) .. "... " end

	return " " .. variable.value
end

M.setup_dap_signs = function(signs)
	for type, icon in pairs(signs) do
		local hl = "Dap" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end
end

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

M.mini.buffers = function()
	require("mini.pick").builtin.buffers(nil, {
		mappings = {
			wipeout = {
				char = "<c-d>",
				func = function() vim.api.nvim_buf_delete(require("mini.pick").get_picker_matches().current.bufnr, {}) end,
			},
		},
	})
end

M.mini.notify.filter_notifications = function(array)
	local filters = {
		"Diagnosing",
		"Processing files",
		"file to analyze",
		"ltex",
	}

	local filter_generator = function(filter)
		return function(notification) return not string.find(notification.msg, filter) end
	end

	for _, filter in pairs(filters) do
		array = vim.tbl_filter(filter_generator(filter), array)
	end

	return require("mini.notify").default_sort(array)
end

return M
