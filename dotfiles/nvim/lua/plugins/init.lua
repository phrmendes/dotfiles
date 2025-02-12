local now, later = require("mini.deps").now, require("mini.deps").later

require("plugins.mini")

now(function()
	require("plugins.dadbod")
	require("plugins.snacks")
end)

later(function()
	require("plugins.blink")
	require("plugins.copilot")
	require("plugins.dap")
	require("plugins.lazydev")
	require("plugins.lsp")
	require("plugins.markdown")
	require("plugins.notes")
	require("plugins.quickfix")
	require("plugins.refactorex")
	require("plugins.slime")
	require("plugins.smart-splits")
	require("plugins.todotxt")
	require("plugins.treesitter")
end)
