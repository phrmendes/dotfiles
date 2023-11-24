local nabla = require("nabla")
local wk = require("which-key")

wk.register({
	p = { nabla.popup, "Equation preview" },
	m = { "<Plug>MarkdownPreviewToggle", "Markdown preview" },
}, { prefix = "<localleader>", mode = "n", buffer = 0 })

wk.register({
	name = "zotero",
	c = { "<Plug>ZCitationCompleteInfo", "Citation info (complete)" },
	i = { "<Plug>ZCitationInfo", "Citation info" },
	o = { "<Plug>ZOpenAttachment", "Open attachment" },
	v = { "<Plug>ZViewDocument", "View exported document" },
	y = { "<Plug>ZCitationYamlRef", "Citation info (yaml)" },
}, { prefix = "<leader>z", mode = "n", buffer = 0 })
