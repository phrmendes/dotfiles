local notify = require("mini.notify")

notify.setup({
	window = { config = { border = vim.g.border } },
	content = {
		sort = function(array)
			local filter_generator = function(filter)
				return function(notification) return not string.find(notification.msg, filter) end
			end

			for _, filter in pairs({
				"Diagnosing",
				"Processing files",
				"file to analyze",
				"ltex",
			}) do
				array = vim.tbl_filter(filter_generator(filter), array)
			end

			return notify.default_sort(array)
		end,
	},
})

vim.notify = MiniNotify.make_notify()
