local M = {}
M.lsp = {}
M.keys = {}

M.match_pattern = function(string, pattern)
	if string:match(pattern) then
		return true
	end

	return false
end

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })

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

M.lsp.provider = function(client, provider, func)
	if client.server_capabilities[provider .. "Provider"] then
		func()
	end
end

M.lsp.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.lsp.on_attach = function(client, bufnr)
	M.keys.map({
		key = "<leader>D",
		cmd = "<ClspD>TroubleToggle workspace_diagnostics<CR>",
		buffer = bufnr,
		desc = "LSP: workspace diagnostics",
	})

	M.keys.map({
		key = "<leader>F",
		cmd = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	M.keys.map({
		key = "<leader>d",
		cmd = "<ClspD>TroubleToggle document_diagnostics<CR>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})

	M.lsp.provider(client, "codeAction", function()
		M.keys.map({
			mode = { "n", "v" },
			key = "<leader>a",
			cmd = require("actions-preview").code_actions,
			buffer = bufnr,
			desc = "LSP: code actions",
		})
	end)

	M.lsp.provider(client, "declaration", function()
		M.keys.map({
			key = "gD",
			cmd = vim.lsp.buf.declaration,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})
	end)

	M.lsp.provider(client, "definition", function()
		M.keys.map({
			key = "gd",
			cmd = "<ClspD>Telescope lsp_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to definition",
		})
	end)

	M.lsp.provider(client, "documentSymbol", function()
		M.keys.map({
			key = "<leader>s",
			cmd = "<ClspD>Telescope lsp_document_symbols<CR>",
			buffer = bufnr,
			desc = "LSP: document symbols",
		})
	end)

	M.lsp.provider(client, "hover", function()
		M.keys.map({
			key = "<leader>k",
			cmd = vim.lsp.buf.hover,
			buffer = bufnr,
			desc = "LSP: show hover documentation",
		})
	end)

	M.lsp.provider(client, "implementation", function()
		M.keys.map({
			key = "gi",
			cmd = "<ClspD>Telescope lsp_implementations<CR>",
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})
	end)

	M.lsp.provider(client, "signatureHelp", function()
		M.keys.map({
			key = "<leader>h",
			cmd = require("lsp_signature").toggle_float_win,
			buffer = bufnr,
			desc = "LSP: toggle signature help",
		})
	end)

	M.lsp.provider(client, "rename", function()
		M.keys.map({
			key = "<leader>r",
			cmd = vim.lsp.buf.rename,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})
	end)

	M.lsp.provider(client, "references", function()
		M.keys.map({
			key = "<leader>R",
			cmd = "<ClspD>Telescope lsp_references<CR>",
			buffer = bufnr,
			desc = "LSP: show references",
		})
	end)

	M.lsp.provider(client, "typeDefinition", function()
		M.keys.map({
			key = "gt",
			cmd = "<ClspD>Telescope lsp_type_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end)

	M.lsp.provider(client, "workspaceSymbol", function()
		M.keys.map({
			key = "<leader>S",
			cmd = "<ClspD>Telescope lsp_workspace_symbols<CR>",
			buffer = bufnr,
			desc = "LSP: workspace symbols",
		})
	end)
end

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
		}

		if args.on_attach then
			setup.on_attach = function(client, bufnr)
				args.on_attach()
				M.lsp.on_attach(client, bufnr)
			end
		else
			setup.on_attach = M.lsp.on_attach
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
