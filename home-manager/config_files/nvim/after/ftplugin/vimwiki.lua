local setup, which_key = pcall(require, "which-key")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

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

map("n", "<Backspace>", "<cmd>VimwikiGoBackLink<cr>", opts)
map("n", "<CR>", "<cmd>VimwikiFollowLink<cr>", opts)
map("n", "<S-Left>", "<cmd>VimwikiTableMoveColumnLeft<cr>", opts)
map("n", "<S-Right>", "<cmd>VimwikiTableMoveColumnRight<cr>", opts)
map("n", "<S-Tab>", "<cmd>VimwikiPrevLink<cr>", opts)
map("n", "<Tab>", "<cmd>VimwikiNextLink<cr>", opts)

which_key.register(normal_mappings, normal_opts)
