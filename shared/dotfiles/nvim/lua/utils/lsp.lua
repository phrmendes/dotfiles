local map = require("utils.keybindings").map

local M = {}

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.on_attach = function(client, bufnr)
	map({
		key = "<leader>D",
		cmd = "<cmd>TroubleToggle workspace_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: workspace diagnostics",
	})

	map({
		key = "<leader>F",
		cmd = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	map({
		mode = { "n", "v" },
		key = "<leader>a",
		cmd = require("actions-preview").code_actions,
		buffer = bufnr,
		desc = "LSP: code actions",
	})

	map({
		key = "<leader>d",
		cmd = "<cmd>TroubleToggle document_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})

	map({
		key = "<leader>h",
		cmd = vim.lsp.buf.signature_help,
		buffer = bufnr,
		desc = "LSP: show signature help",
	})

	map({
		key = "<leader>k",
		cmd = vim.lsp.buf.hover,
		buffer = bufnr,
		desc = "LSP: show hover documentation",
	})

	if client.server_capabilities.documentSymbolProvider then
		map({
			key = "<leader>S",
			cmd = "<cmd>Telescope lsp_workspace_symbols<cr>",
			buffer = bufnr,
			desc = "LSP: workspace symbols",
		})

		map({
			key = "<leader>r",
			cmd = vim.lsp.buf.rename,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})

		map({
			key = "<leader>s",
			cmd = "<cmd>Telescope lsp_document_symbols<cr>",
			buffer = bufnr,
			desc = "LSP: document symbols",
		})

		map({
			key = "gD",
			cmd = vim.lsp.buf.declaration,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})

		map({
			key = "gd",
			cmd = "<cmd>Telescope lsp_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to definition",
		})

		map({
			key = "gi",
			cmd = "<cmd>Telescope lsp_implementations<cr>",
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})

		map({
			key = "gr",
			cmd = "<cmd>Telescope lsp_references<cr>",
			buffer = bufnr,
			desc = "LSP: go to references",
		})

		map({
			key = "gt",
			cmd = "<cmd>Telescope lsp_type_definitions<cr>",
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end
end

M.add_language_server = function(args)
	local lspconfig = require("lspconfig")
	local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
	local setup

	if args.setup then
		setup = args.setup
	else
		setup = {
			capabilities = args.capabilities or default_capabilities,
			handlers = args.handlers or M.handlers,
		}

		if args.on_attach then
			setup.on_attach = function(client, bufnr)
				args.on_attach()
				M.on_attach(client, bufnr)
			end
		else
			setup.on_attach = M.on_attach
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
