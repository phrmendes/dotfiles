require("plugins.lsp.ui")
require("plugins.lsp.servers")
require("plugins.lsp.ltex")
require("plugins.lsp.formatters")
require("plugins.lsp.linters")

if vim.fn.has("mac") == 0 then
	require("plugins.lsp.metals")
end
