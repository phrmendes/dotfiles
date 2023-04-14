local status, quarto = pcall(require, "quarto")
if not status then
	return
end

quarto.setup({
	debug = false,
	closePreviewOnExit = true,
	lspFeatures = {
		enabled = true,
		languages = { "python", "bash" },
		chunks = "curly",
		diagnostics = {
			enabled = true,
			triggers = { "BufWritePost" },
		},
		completion = {
			enabled = true,
		},
	},
	keymap = {
		hover = "K",
		definition = "gd",
	},
})
