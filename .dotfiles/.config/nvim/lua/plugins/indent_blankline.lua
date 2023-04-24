local status, indent_blankline = pcall(require, "indent_blankline")
if not status then
	return
end

indent_blankline.setup({
	opts = {
		char = "┊",
		show_trailing_blankline_indent = false,
	},
})
