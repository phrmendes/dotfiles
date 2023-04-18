local status, bufferline = pcall(require, "bufferline")
if not status then
	return
end

bufferline.setup({
	options = {
		offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
		numbers = "none",
		diagnostics = "nvim_lsp",
		separator_style = "thin",
		show_tab_indicators = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
	},
})