require("mini.notify").setup({
	content = { sort = require("utils").mini.notify.filter_notifications },
	window = { config = { border = require("utils").borders.border } },
})

vim.notify = require("mini.notify").make_notify()
