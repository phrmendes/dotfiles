local mappings = require("plugins.writing")

mappings.markdown()
mappings.bullets()

if vim.fn.has("mac") == 0 then
	mappings.zotero()
end
