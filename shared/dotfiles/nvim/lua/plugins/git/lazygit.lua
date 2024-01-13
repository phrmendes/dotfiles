local utils = require("utils")

utils.map({
	key = "<leader>gcr",
	cmd = "<cmd>LazyGitFilter<cr>",
	desc = "Repository",
})

utils.map({
	key = "<leader>gcf",
	cmd = "<cmd>LazyGitFilterCurrentFile<cr>",
	desc = "File",
})

utils.map({
	key = "<leader>gg",
	cmd = "<cmd>LazyGit<cr>",
	desc = "LazyGit",
})

utils.map({
	key = "<leader>gl",
	cmd = "<cmd>Telescope lazygit<cr>",
	desc = "List repos",
})
