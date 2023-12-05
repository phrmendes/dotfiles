local map = vim.keymap.set

map("n", "<localleader>m", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview", buffer = 0 })

if vim.fn.has("mac") == 0 then
	map("n", "<localleader>e", require("nabla").popup, { desc = "Equation preview", buffer = 0 })

	require("which-key").register({
		mode = "n",
		buffer = 0,
		["<leader>z"] = { name = "zotero" },
	})

	map("n", "<leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)", buffer = 0 })
	map("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info", buffer = 0 })
	map("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment", buffer = 0 })
	map("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "View exported document", buffer = 0 })
	map("n", "<leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)", buffer = 0 })
end
