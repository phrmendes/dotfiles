require("mini.notify").setup({
	content = { sort = require("utils").mini.notify.filter_notifications },
	window = { config = { border = require("utils").borders.border } },
})
