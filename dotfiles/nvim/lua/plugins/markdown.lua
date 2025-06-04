local add = MiniDeps.add
local later = MiniDeps.later

add({ source = "tadmccorkle/markdown.nvim" })

local build = function() vim.fn["mkdp#util#install"]() end

add({
	source = "iamcco/markdown-preview.nvim",
	hooks = {
		post_install = function() later(build) end,
		post_checkout = build,
	},
})

require("markdown").setup({
	on_attach = function(bufnr)
		local map = vim.keymap.set

		map({ "n", "i" }, "<c-c>k", "<Cmd>MDListItemAbove<CR>", { buffer = bufnr, desc = "markdown: add item above" })
		map({ "n", "i" }, "<c-c>j", "<Cmd>MDListItemBelow<CR>", { buffer = bufnr, desc = "markdown: add item below" })
		map("n", "<c-x>", "<cmd>MDTaskToggle<CR>", { buffer = bufnr, desc = "markdown: toggle checkbox" })
		map("x", "<c-x>", ":MDTaskToggle<CR>", { buffer = bufnr, desc = "markdown: toggle checkbox" })
		map("i", "<c-i>", require("helpers").toggle_emphasis("i"), { buffer = bufnr, desc = "markdown: toggle italic" })
		map("i", "<c-b>", require("helpers").toggle_emphasis("b"), { buffer = bufnr, desc = "markdown: toggle bold" })
		map("n", "<leader>p", "<cmd>MarkdownPreviewToggle<CR>", { buffer = bufnr, desc = "markdown: toggle preview" })
	end,
})
