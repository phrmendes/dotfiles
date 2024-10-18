local augroup = vim.api.nvim_create_augroup

local M = {}

M.mini = {}
M.mini.notify = {}
M.mini.files = {}
M.mini.pick = {}

M.augroups = {
	filetype = augroup("UserFileType", { clear = true }),
	mini = augroup("UserMini", { clear = true }),
	yank = augroup("UserYank", { clear = true }),
	lsp = {
		attach = augroup("UserLspAttach", { clear = true }),
		detach = augroup("UserLspDetach", { clear = true }),
		highlight = augroup("UserLspHighlight", { clear = true }),
		lint_format = augroup("UserLspLintFormat", { clear = true }),
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
		return c:gsub("[ÁÀÂ]", "A")
			:gsub("[ÉÈÊ]", "E")
			:gsub("[ÍÌÎ]", "I")
			:gsub("[ÓÒÔ]", "O")
			:gsub("[ÚÙÛ]", "U")
			:gsub("[Ç]", "C")
			:gsub("[áàâ]", "a")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
			:gsub("[ç]", "c")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.open = function(obj)
	vim.fn.jobstart({ "xdg-open", obj })
end

M.borders = {
	border = "rounded",
	winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

M.capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
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

M.config_server = function(opts)
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

M.image_name = function()
	local prefix = os.date("%Y%m%d%H%M%S")
	local suffix = vim.fn.expand("%:p:t:r")

	return prefix .. "-" .. suffix .. "-"
end

M.note_id = function(title)
	local prefix = os.date("%Y%m%d%H%M%S")
	local suffix = M.normalize(title)

	return prefix .. "-" .. suffix
end

M.note_frontmatter = function(note)
	if note.title then
		note:add_alias(note.title)
	end

	local header = {
		id = note.id,
		aliases = note.aliases,
		tags = note.tags,
	}

	if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
		for k, v in pairs(note.metadata) do
			header[k] = v
		end
	end

	return header
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

M.get_clients = function(opts)
	local ret = {}

	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)

		if opts and opts.method then
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end

	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

M.mini.notify.filter_notifications = function(array)
	local filters = {
		"Diagnosing",
		"ansible-lint",
		"file to analyze",
		"ltex",
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

M.mini.files.filter_show = function()
	return true
end

M.mini.files.filter_hide = function(fs_entry)
	return not vim.startswith(fs_entry.name, ".")
end

M.mini.files.toggle_dotfiles = function()
	vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles
	local new_filter = vim.g.mini_show_dotfiles and M.mini.files.filter_show or M.mini.files.filter_hide
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

M.mini.files.on_rename = function(from, to)
	local changes = {
		files = {
			{
				oldUri = vim.uri_from_fname(from),
				newUri = vim.uri_from_fname(to),
			},
		},
	}

	local clients = M.get_clients()

	for _, client in ipairs(clients) do
		if client.supports_method("workspace/willRenameFiles") then
			local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)

			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end

	for _, client in ipairs(clients) do
		if client.supports_method("workspace/didRenameFiles") then
			client.notify("workspace/didRenameFiles", changes)
		end
	end
end

return M
