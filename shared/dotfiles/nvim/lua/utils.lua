local M = {}

M.lsp = {}
M.lsp.simple = {}

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })

M.normalize = function(word)
	local normalized_word = word:lower():gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
		return c:gsub("[ÁÀÂ]", "A")
			:gsub("[Ç]", "C")
			:gsub("[ÉÈÊ]", "E")
			:gsub("[ÍÌÎ]", "I")
			:gsub("[ÓÒÔ]", "O")
			:gsub("[ÚÙÛ]", "U")
			:gsub("[áàâ]", "a")
			:gsub("[ç]", "c")
			:gsub("[éèê]", "e")
			:gsub("[íìî]", "i")
			:gsub("[óòô]", "o")
			:gsub("[úùû]", "u")
	end)

	return normalized_word:gsub("[%s%W]", "_")
end

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

M.section = function(args)
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

M.map = function(args, user_opts)
	local opts = {
		mode = args.mode or "n",
		key = args.key,
		command = args.command,
		keymap_opts = {
			desc = args.desc,
			buffer = args.buffer or nil,
		},
	}

	if user_opts then
		opts.keymap_opts = vim.tbl_extend("force", opts.keymap_opts, user_opts)
	end

	vim.keymap.set(opts.mode, opts.key, opts.command, opts.keymap_opts)
end

M.venv = function()
	if vim.env.CONDA_DEFAULT_ENV then
		return string.format(" %s (conda)", vim.env.CONDA_DEFAULT_ENV)
	end

	if vim.env.VIRTUAL_ENV then
		return string.format(" %s (venv)", vim.fn.fnamemodify(vim.env.VIRTUAL_ENV, ":t"))
	end

	return ""
end

M.lsp.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.lsp.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.lsp.on_attach = function(_, bufnr)
	M.map({
		key = "<leader>D",
		command = "<cmd>TroubleToggle workspace_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: workspace diagnostics",
	})

	M.map({
		key = "<leader>F",
		command = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	M.map({
		key = "<leader>S",
		command = "<cmd>Telescope lsp_workspace_symbols<cr>",
		buffer = bufnr,
		desc = "LSP: workspace symbols",
	})

	M.map({
		mode = { "n", "v" },
		key = "<leader>a",
		command = vim.lsp.buf.code_action,
		buffer = bufnr,
		desc = "LSP: code actions",
	})

	M.map({
		key = "<leader>d",
		command = "<cmd>TroubleToggle document_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})

	M.map({
		key = "<leader>h",
		command = vim.lsp.buf.signature_help,
		buffer = bufnr,
		desc = "LSP: show signature help",
	})

	M.map({
		key = "<leader>k",
		command = vim.lsp.buf.hover,
		buffer = bufnr,
		desc = "LSP: show hover documentation",
	})

	M.map({
		key = "<leader>r",
		command = vim.lsp.buf.rename,
		buffer = bufnr,
		desc = "LSP: rename symbol",
	})

	M.map({
		key = "<leader>s",
		command = "<cmd>Telescope lsp_document_symbols<cr>",
		buffer = bufnr,
		desc = "LSP: document symbols",
	})

	M.map({
		key = "gD",
		command = vim.lsp.buf.declaration,
		buffer = bufnr,
		desc = "LSP: go to declaration",
	})

	M.map({
		key = "gd",
		command = "<cmd>Telescope lsp_definitions<CR>",
		buffer = bufnr,
		desc = "LSP: go to definition",
	})

	M.map({
		key = "gi",
		command = "<cmd>Telescope lsp_implementations<cr>",
		buffer = bufnr,
		desc = "LSP: go to implementations",
	})

	M.map({
		key = "gr",
		command = "<cmd>Telescope lsp_references<cr>",
		buffer = bufnr,
		desc = "LSP: go to references",
	})

	M.map({
		key = "gt",
		command = "<cmd>Telescope lsp_type_definitions<cr>",
		buffer = bufnr,
		desc = "LSP: go to type definition",
	})
end

M.lsp.simple.capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities.textDocument.completion.completionItem.snippetSupport = true

	return capabilities
end

M.lsp.simple.on_attach = function(_, bufnr)
	M.map({
		key = "<leader>F",
		command = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	M.map({
		mode = { "n", "v" },
		key = "<leader>a",
		command = vim.lsp.buf.code_action,
		buffer = bufnr,
		desc = "LSP: code actions",
	})

	M.map({
		key = "<leader>d",
		command = "<cmd>TroubleToggle document_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})
end

M.lsp.add_server = function(args)
	local opts = {
		server = args.server,
		setup = {
			capabilities = args.capabilities or M.lsp.capabilities,
			on_attach = args.on_attach or M.lsp.on_attach,
			handlers = args.handlers or M.lsp.handlers,
			settings = args.settings or {},
		},
	}

	require("lspconfig")[opts.server].setup(opts.setup)
end

return M
