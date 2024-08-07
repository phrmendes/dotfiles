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
	require("plugins.dadbod")
	require("plugins.dap")
	require("plugins.dial")
	require("plugins.executor")
	require("plugins.formatters")
	require("plugins.image")
	require("plugins.kulala")
	require("plugins.linters")
	require("plugins.lsp")
	require("plugins.luasnip")
	require("plugins.neodev")
	require("plugins.neogen")
	require("plugins.obsidian")
	require("plugins.quarto")
	require("plugins.quickfix")
	require("plugins.refactoring")
	require("plugins.slime")
	require("plugins.treesitter")
	require("plugins.yanky")
	require("plugins.zen")
end)
