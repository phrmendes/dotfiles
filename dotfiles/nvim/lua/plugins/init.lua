local now, later = require("mini.deps").now, require("mini.deps").later

require("plugins.mini")

now(function()
	require("plugins.dressing")
end)

later(function()
	require("plugins.autotag")
	require("plugins.better-escape")
	require("plugins.colorizer")
	require("plugins.completion")
	require("plugins.copilot")
	require("plugins.curl-nvim")
	require("plugins.dadbod")
	require("plugins.dap")
	require("plugins.dial")
	require("plugins.formatters")
	require("plugins.image")
	require("plugins.linters")
	require("plugins.lsp")
	require("plugins.luasnip")
	require("plugins.neogen")
	require("plugins.obsidian")
	require("plugins.pandoc")
	require("plugins.quickfix")
	require("plugins.refactoring")
	require("plugins.slime")
	require("plugins.telescope")
	require("plugins.treesitter")
	require("plugins.zotcite")
end)
