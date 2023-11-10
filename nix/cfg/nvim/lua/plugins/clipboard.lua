local clipboard = require("clipboard-image")

clipboard.setup({
	default = {
		img_dir = { "%:p:h", "attachments" },
	},
	markdown = {
		img_dir_txt = "attachments",
		affix = "![[%s]]",
		img_name = function()
			vim.fn.inputsave()
			local name = vim.fn.input("Name: ")
			vim.fn.inputrestore()

			local suffix = "_" .. os.date("%Y%m%d%H%M%S")

			if name == nil or name == "" then
				return vim.fn.expand("%:t:r") .. suffix
			end

			return name .. "_" .. suffix
		end,
	},
})
