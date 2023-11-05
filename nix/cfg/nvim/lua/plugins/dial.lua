local augend = require("dial.augend")
local config = require("dial.config")

config.augends:register_group({
	default = {
		augend.date.alias["%H:%M"],
		augend.date.alias["%m/%d"],
		augend.date.alias["%d/%m/%Y"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%Y/%m/%d"],
		augend.constant.alias.bool,
		augend.integer.alias.decimal_int,
		augend.semver.alias.semver,
	},
	visual = {
		augend.constant.alias.Alpha,
		augend.constant.alias.alpha,
		augend.integer.alias.decimal_int,
	},
	python = {
		augend.integer.alias.decimal_int,
		augend.constant.new({
			elements = { "True", "False" },
			word = false,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "and", "or" },
			word = false,
			cyclic = true,
		}),
	},
})
