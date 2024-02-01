local map = require("utils.keybindings").map

local M = {}

local provider = function(client, provider, func)
	if client.server_capabilities[provider .. "Provider"] then
		func()
	end
end

M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.on_attach = function(client, bufnr)
	map({
		key = "<leader>D",
		cmd = "<CMD>TroubleToggle workspace_diagnostics<CR>",
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
		key = "<leader>d",
		cmd = "<CMD>TroubleToggle document_diagnostics<CR>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})

	provider(client, "codeAction", function()
		map({
			mode = { "n", "v" },
			key = "<leader>a",
			cmd = require("actions-preview").code_actions,
			buffer = bufnr,
			desc = "LSP: code actions",
		})
	end)

	provider(client, "declaration", function()
		map({
			key = "gD",
			cmd = vim.lsp.buf.declaration,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})
	end)

	provider(client, "definition", function()
		map({
			key = "gd",
			cmd = "<CMD>Telescope lsp_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to definition",
		})
	end)

	provider(client, "documentSymbol", function()
		map({
			key = "<leader>s",
			cmd = "<CMD>Telescope lsp_document_symbols<CR>",
			buffer = bufnr,
			desc = "LSP: document symbols",
		})
	end)

	provider(client, "hover", function()
		map({
			key = "<leader>k",
			cmd = vim.lsp.buf.hover,
			buffer = bufnr,
			desc = "LSP: show hover documentation",
		})
	end)

	provider(client, "implementation", function()
		map({
			key = "gi",
			cmd = "<CMD>Telescope lsp_implementations<CR>",
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})
	end)

	provider(client, "signatureHelp", function()
		map({
			key = "<leader>h",
			cmd = require("lsp_signature").toggle_float_win,
			buffer = bufnr,
			desc = "LSP: toggle signature help",
		})
	end)

	provider(client, "rename", function()
		map({
			key = "<leader>r",
			cmd = vim.lsp.buf.rename,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})
	end)

	provider(client, "references", function()
		map({
			key = "<leader>R",
			cmd = "<CMD>Telescope lsp_references<CR>",
			buffer = bufnr,
			desc = "LSP: show references",
		})
	end)

	provider(client, "typeDefinition", function()
		map({
			key = "gt",
			cmd = "<CMD>Telescope lsp_type_definitions<CR>",
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end)

	provider(client, "workspaceSymbol", function()
		map({
			key = "<leader>S",
			cmd = "<CMD>Telescope lsp_workspace_symbols<CR>",
			buffer = bufnr,
			desc = "LSP: workspace symbols",
		})
	end)
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
