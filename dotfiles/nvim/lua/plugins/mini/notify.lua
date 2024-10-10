require("mini.notify").setup({
	content = { sort = require("utils").filter_notifications },
	window = { config = { border = require("utils").borders.border } },
})
