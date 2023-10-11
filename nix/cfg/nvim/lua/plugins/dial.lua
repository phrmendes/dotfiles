local augend = require("dial.augend")
local config = require("dial.config")

config.augends:register_group({
	default = {
		augend.date.alias["%H:%M"],
		augend.date.alias["%m/%d"],
		augend.date.alias["%d/%m/%Y"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%Y/%m/%d"],
		augend.integer.alias.decimal,
		augend.semver.alias.semver,
		augend.constant.alias.bool,
	},
	visual = {
		augend.constant.alias.Alpha,
		augend.constant.alias.alpha,
		augend.integer.alias.decimal,
	},
	python = {
		augend.integer.alias.decimal,
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
