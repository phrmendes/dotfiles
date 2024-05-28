local notes_path = vim.env.NOTES_PATH or vim.env.HOME .. "/Documents/notes"

require("image").setup({
	backend = "kitty",
	integrations = {
		markdown = {
			filetypes = { "markdown", "quarto" },
		},
	},
})

local opts = {
	url_encode_path = true,
	template = "![$CURSOR]($FILE_PATH)",
	download_images = true,
}

require("img-clip").setup({
	filetypes = {
		md = opts,
		qmd = opts,
	},
	dirs = {
		[tostring(notes_path)] = {
			prompt_for_file_name = false,
			file_name = function()
				local name = vim.fn.input("File name: ")
				return os.date("%Y%m%d%H%M%S") .. "-" .. vim.fn.expand("%:t:r") .. "-" .. name
			end,
			drag_and_drop = {
				enabled = true,
				insert_mode = true,
			},
		},
	},
})
