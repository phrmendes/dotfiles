local notify = require("mini.notify")

local filter_ltex = function(notification_array)
	local ltex = function(notification)
		return not vim.startswith(notification.msg, "ltex")
	end

	notification_array = vim.tbl_filter(ltex, notification_array)
	return notify.default_sort(notification_array)
end

notify.setup({
	content = { sort = filter_ltex },
	window = { config = { border = require("utils").borders.border } },
})
