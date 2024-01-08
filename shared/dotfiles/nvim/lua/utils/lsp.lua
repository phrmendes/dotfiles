local map = require("utils.keybindings").map

local M = {}

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.on_attach = function(client, bufnr)
	map({
		key = "<leader>D",
		command = "<cmd>TroubleToggle workspace_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: workspace diagnostics",
	})

	map({
		key = "<leader>F",
		command = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	map({
		mode = { "n", "v" },
		key = "<leader>a",
		command = require("actions-preview").code_actions,
		buffer = bufnr,
		desc = "LSP: code actions",
	})

	map({
		key = "<leader>d",
		command = "<cmd>TroubleToggle document_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})

	map({
		key = "<leader>h",
		command = vim.lsp.buf.signature_help,
		buffer = bufnr,
		desc = "LSP: show signature help",
	})

	map({
		key = "<leader>k",
		command = vim.lsp.buf.hover,
		buffer = bufnr,
		desc = "LSP: show hover documentation",
	})

	if client.server_capabilities.documentSymbolProvider then
		map({
			key = "<leader>S",
			command = "<cmd>Telescope lsp_workspace_symbols<cr>",
			buffer = bufnr,
			desc = "LSP: workspace symbols",
		})

		map({
			key = "<leader>r",
			command = vim.lsp.buf.rename,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})

		map({
			key = "<leader>s",
			command = "<cmd>Telescope lsp_document_symbols<cr>",
			buffer = bufnr,
			desc = "LSP: document symbols",
		})

		map({
			key = "gD",
			command = vim.lsp.buf.declaration,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})

		map({
			key = "gd",
			command = "<cmd>Telescope lsp_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to definition",
		})

		map({
			key = "gi",
			command = "<cmd>Telescope lsp_implementations<cr>",
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})

		map({
			key = "gr",
			command = "<cmd>Telescope lsp_references<cr>",
			buffer = bufnr,
			desc = "LSP: go to references",
		})

		map({
			key = "gt",
			command = "<cmd>Telescope lsp_type_definitions<cr>",
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end
end

M.add_language_server = function(args)
	local opts = {
		server = args.server,
		setup = {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(client, bufnr)
				if args.on_attach then
					args.on_attach()
				end

				M.on_attach(client, bufnr)
			end,
			handlers = args.handlers or M.handlers,
			settings = args.settings or {},
		},
	}

	require("lspconfig")[opts.server].setup(opts.setup)
end

return M