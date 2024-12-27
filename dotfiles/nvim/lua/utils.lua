local augroup = vim.api.nvim_create_augroup

local M = {}

M.mini = {}
M.mini.files = {}
M.mini.notify = {}
M.mini.pick = {}
M.mini.git = {}

M.augroups = {
	filetype = augroup("UserFileType", { clear = true }),
	mini = augroup("UserMini", { clear = true }),
	yank = augroup("UserYank", { clear = true }),
	windows = augroup("UserWindows", { clear = true }),
	lsp = {
		attach = augroup("UserLspAttach", { clear = true }),
		detach = augroup("UserLspDetach", { clear = true }),
		efm = augroup("UserLspEfm", { clear = true }),
		highlight = augroup("UserLspHighlight", { clear = true }),
	},
}

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

M.normalize = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
			:gsub("[ç]", "c")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.borders = {
	border = "rounded",
	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

M.capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

	capabilities.textDocument.completion.completionItem.snippetSupport = true

	return capabilities
end

M.config_diagnostics = function(signs, config)
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	vim.diagnostic.config(config)
end

M.config_lsp_server = function(opts)
	local settings = opts.settings or {}

	settings.capabilities = vim.tbl_deep_extend("force", {}, {
		capabilites = opts.capabilities or M.capabilities(),
	})

	settings.handlers = {
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, M.borders),
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, M.borders),
	}

	require("lspconfig")[opts.server].setup(settings)
end

M.display_callback = function(variable)
	if #variable.value > 15 then
		return " " .. string.sub(variable.value, 1, 15) .. "... "
	end

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

M.toggle_checkbox = function()
	local checked_character = "x"

	local checked_checkbox = "%[" .. checked_character .. "%]"
	local unchecked_checkbox = "%[ %]"

	local line_contains_unchecked = function(line)
		return line:find(unchecked_checkbox)
	end

	local line_contains_checked = function(line)
		return line:find(checked_checkbox)
	end

	local line_with_checkbox = function(line)
		-- return not line_contains_a_checked_checkbox(line) and not line_contains_an_unchecked_checkbox(line)
		return line:find("^%s*- " .. checked_checkbox)
			or line:find("^%s*- " .. unchecked_checkbox)
			or line:find("^%s*%d%. " .. checked_checkbox)
			or line:find("^%s*%d%. " .. unchecked_checkbox)
	end

	local checkbox = {
		check = function(line)
			return line:gsub(unchecked_checkbox, checked_checkbox, 1)
		end,

		uncheck = function(line)
			return line:gsub(checked_checkbox, unchecked_checkbox, 1)
		end,

		make_checkbox = function(line)
			if not line:match("^%s*-%s.*$") and not line:match("^%s*%d%s.*$") then
				-- "xxx" -> "- [ ] xxx"
				return line:gsub("(%S+)", "- [ ] %1", 1)
			else
				-- "- xxx" -> "- [ ] xxx", "3. xxx" -> "3. [ ] xxx"
				return line:gsub("(%s*- )(.*)", "%1[ ] %2", 1):gsub("(%s*%d%. )(.*)", "%1[ ] %2", 1)
			end
		end,
	}

	local toggle = function()
		local bufnr = vim.fn.bufnr("%")
		local cursor = vim.api.nvim_win_get_cursor(0)
		local start_line = cursor[1] - 1
		local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

		local new_line = ""

		if not line_with_checkbox(current_line) then
			new_line = checkbox.make_checkbox(current_line)
		elseif line_contains_unchecked(current_line) then
			new_line = checkbox.check(current_line)
		elseif line_contains_checked(current_line) then
			new_line = checkbox.uncheck(current_line)
		end

		vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
		vim.api.nvim_win_set_cursor(0, cursor)
	end

	return toggle()
end

M.mini.buffers = function()
	require("mini.pick").builtin.buffers(nil, {
		mappings = {
			wipeout = {
				char = "<c-d>",
				func = function()
					vim.api.nvim_buf_delete(require("mini.pick").get_picker_matches().current.bufnr, {})
				end,
			},
		},
	})
end

M.mini.files.toggle_dotfiles = function()
	local filter_show = function()
		return true
	end

	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end

	vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles
	local new_filter = vim.g.mini_show_dotfiles and filter_show or filter_hide
	require("mini.files").refresh({ content = { filter = new_filter } })
end

M.mini.files.map_split = function(direction, close_on_file)
	return function()
		local new_target_window
		local current_target_window = require("mini.files").get_explorer_state().target_window
		if current_target_window ~= nil then
			vim.api.nvim_win_call(current_target_window, function()
				vim.cmd("belowright " .. direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)
			require("mini.files").set_target_window(new_target_window)
			require("mini.files").go_in({ close_on_file = close_on_file })
		end
	end
end

M.mini.files.set_cwd = function()
	local current_entry_path = require("mini.files").get_fs_entry().path
	local current_directory = vim.fs.dirname(current_entry_path)
	if current_directory ~= nil then
		vim.fn.chdir(current_directory)
	end
end

M.mini.notify.filter_notifications = function(array)
	local filters = {
		"Diagnosing",
		"Processing files",
		"file to analyze",
	}

	local filter_generator = function(filter)
		return function(notification)
			return not string.find(notification.msg, filter)
		end
	end

	for _, filter in pairs(filters) do
		array = vim.tbl_filter(filter_generator(filter), array)
	end

	return require("mini.notify").default_sort(array)
end

return M
