local mappings = require("plugins.writing")

mappings.markdown()

if vim.fn.has("mac") == 0 then
	mappings.zotero()
end
