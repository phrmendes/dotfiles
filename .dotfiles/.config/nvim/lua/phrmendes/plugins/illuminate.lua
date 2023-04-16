local setup, illuminate = pcall(require, "illuminate")
if not setup then
	return
end

illuminate.configure({
	providers = {
		"lsp",
		"treesitter",
	},
	delay = 100,
	under_cursor = true,
	large_file_cutoff = nil,
	large_file_overrides = nil,
	min_count_to_highlight = 1,
})
