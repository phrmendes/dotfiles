local setup, sniprun = pcall(require, "sniprun")
if not setup then
	return
end

sniprun.setup({
	display = { "TerminalWithCode" },
	selected_interpreters = { "Python3_fifo" },
	repl_enable = { "Python3_fifo" },
})
