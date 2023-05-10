local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local normal_opts = {
	mode = "n",
	prefix = "<localleader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local normal_mappings = {
	["<Backspace>"] = { "<cmd>VimwikiGoBackLink<cr>", "Vimwiki - Go back" },
	["<CR>"] = { "<cmd>VimwikiFollowLink<cr>", "Vimwiki - Follow link" },
	["<Left>"] = { "<cmd>VimwikiTableMoveColumnLeft<cr>", "Vimwiki - Move table column to left" },
	["<Right>"] = { "<cmd>VimwikiTableMoveColumnRight<cr>", "Vimwiki - Move table column to right" },
	["<S-Tab>"] = { "<cmd>VimwikiPrevLink<cr>", "Vimwiki - Next link" },
	["<Tab>"] = { "<cmd>VimwikiNextLink<cr>", "Vimwiki - Next link" },
	["a"] = { "<cmd>VimwikiTableAlignQ<cr>", "Vimwiki - Align table" },
	["b"] = { "<cmd>VimwikiBacklinks<cr>", "Vimwiki - Backlinks" },
	["c"] = { "<cmd>VimwikiCheckLinks<cr>", "Vimwiki - Check links" },
	["d"] = { "<cmd>VimwikiDeleteFile<cr>", "Vimwiki - Delete file" },
	["e"] = { "<cmd>Vimwiki2HTMLBrowse<cr>", "Vimwiki - Export wiki to HTML" },
	["g"] = { "<cmd>VimwikiGoto<cr>", "Vimwiki - Go to or create new wiki page" },
	["n"] = { "<cmd>VimwikiNextTask<cr>", "Vimwiki - Next task" },
	["r"] = { "<cmd>VimwikiRenameFile<cr>", "Vimwiki - Rename file" },
	["t"] = { "<cmd>VimwikiTOC<cr>", "Vimwiki - Table of contents" },
	["x"] = { "<cmd>VimwikiToggleListItem<cr>", "Vimwiki - Toggle list item" },
}

which_key.register(normal_mappings, normal_opts)
