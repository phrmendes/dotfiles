local notify = require("mini.notify")

local filters = function(notification_array)
	local filters = {
		"ltex",
		"file to analyze",
		"Diagnosing",
	}

	local filter_generator = function(filter)
		return function(notification)
			return not string.find(notification.msg, filter)
		end
	end

	for _, filter in pairs(filters) do
		notification_array = vim.tbl_filter(filter_generator(filter), notification_array)
	end

	return notify.default_sort(notification_array)
end

notify.setup({
	content = { sort = filters },
	window = { config = { border = require("utils").borders.border } },
})
