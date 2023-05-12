local setup, goto_preview = pcall(require, "goto-preview")
if not setup then
	return
end

goto_preview.setup()
