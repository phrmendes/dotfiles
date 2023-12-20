local diagnostics_signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(diagnostics_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = require("utils").border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = require("utils").border,
})
