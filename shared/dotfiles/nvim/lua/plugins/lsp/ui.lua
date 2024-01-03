require("barbecue").setup({ exclude_filetypes = { "Starter", "Trouble", "neo-tree", "markdown", "quarto" } })
require("lsp_signature").setup()
require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	float = { border = "rounded" },
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
