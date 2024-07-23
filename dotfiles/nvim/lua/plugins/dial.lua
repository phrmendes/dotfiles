local augend = require("dial.augend")

require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal_int,
		augend.constant.alias.bool,
	},
	lua = {
		augend.integer.alias.decimal_int,
		augend.constant.alias.bool,
		augend.constant.new({
			elements = { "and", "or" },
			word = true,
			cyclic = true,
		}),
	},
	python = {
		augend.integer.alias.decimal_int,
		augend.constant.new({
			elements = { "True", "False" },
			word = true,
			cyclic = true,
		}),
		augend.constant.new({
			elements = { "and", "or" },
			word = true,
			cyclic = true,
		}),
	},
	go = {
		augend.integer.alias.decimal_int,
		augend.constant.alias.bool,
		augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		}),
	},
	markdown = {
		augend.constant.new({
			elements = { "#", "##", "###", "####", "#####" },
			word = false,
			cyclic = true,
		}),
	},
})
