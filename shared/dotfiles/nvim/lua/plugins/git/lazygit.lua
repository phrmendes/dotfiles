local utils = require("utils")

utils.map({
	key = "<leader>gcr",
	cmd = "<CMD>LazyGitFilter<CR>",
	desc = "Repository",
})

utils.map({
	key = "<leader>gcf",
	cmd = "<CMD>LazyGitFilterCurrentFile<CR>",
	desc = "File",
})

utils.map({
	key = "<leader>gg",
	cmd = "<CMD>LazyGit<CR>",
	desc = "LazyGit",
})

utils.map({
	key = "<leader>gl",
	cmd = "<CMD>Telescope lazygit<CR>",
	desc = "List repos",
})
