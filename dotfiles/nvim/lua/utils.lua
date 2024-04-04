local M = {}
M.lsp = {}
M.keys = {}

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

M.normalize = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[áàâ]", "a")
			:gsub("[ç]", "c")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.metadata = function(note)
	local out = { aliases = note.aliases, tags = note.tags }
	if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
		for k, v in pairs(note.metadata) do
			out[k] = v
		end
	end

	return out
end

M.open = function(arg)
	local open

	if vim.fn.has("mac") == 1 then
		open = { "open", arg }
	else
		open = { "xdg-open", arg }
	end

	vim.fn.jobstart(open)
end

M.keys.section = function(args)
	local opts = {
		buffer = args.buffer or nil,
		key = args.key,
		mode = args.mode or "n",
		name = args.name,
	}

	require("which-key").register({
		mode = opts.mode,
		buffer = opts.buffer,
		[opts.key] = { name = opts.name },
	})
end

M.keys.map = function(args, user_opts)
	local opts = {
		mode = args.mode or "n",
		key = args.key,
		cmd = args.cmd,
		keymap_opts = {
			desc = args.desc,
			buffer = args.buffer or nil,
		},
	}

	if user_opts then
		opts.keymap_opts = vim.tbl_extend("force", opts.keymap_opts, user_opts)
	end

	vim.keymap.set(opts.mode, opts.key, opts.cmd, opts.keymap_opts)
end

M.lsp.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.lsp.flags = {
	allow_incremental_sync = true,
	debounce_text_changes = 150,
}

M.lsp.add_language_server = function(args)
	local lspconfig = require("lspconfig")
	local setup
	local default_capabilities = vim.lsp.protocol.make_client_capabilities()

	default_capabilities =
		vim.tbl_deep_extend("force", default_capabilities, require("cmp_nvim_lsp").default_capabilities())

	if args.setup then
		setup = args.setup
	else
		setup = {
			capabilities = args.capabilities or default_capabilities,
			handlers = args.handlers or M.lsp.handlers,
			flags = args.flags or M.lsp.flags,
		}

		if args.on_attach then
			setup.on_attach = args.on_attach
		end

		if args.filetypes then
			setup.filetypes = args.filetypes
		end

		if args.settings then
			setup.settings = args.settings
		end
	end

	lspconfig[args.server].setup(setup)
end

return M
