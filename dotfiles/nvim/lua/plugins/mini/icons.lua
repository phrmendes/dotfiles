local icons = require("mini.icons")

icons.setup({
	lsp = {
		copilot = { glyph = "", hl = "MiniIconsOrange" },
		otter = { glyph = "🦦", hl = "MiniIconsCyan" },
		ellipsis_char = { glyph = "…", hl = "MiniIconsRed" },
	},
	file = {
		[".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
		[".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
		[".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
		[".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
		["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
		["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
		["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
		["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
		["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
	},
})
