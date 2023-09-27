-- [[ variables ]] ------------------------------------------------------
local g = vim.g
local map = vim.keymap.set

-- [[ imports ]] --------------------------------------------------------
local bufremove = require("mini.bufremove")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local todos = require("todo-comments")
local wk = require("which-key")

local telescope = {
	builtin = require("telescope.builtin"),
	extensions = require("telescope").extensions,
	themes = require("telescope.themes"),
}

-- [[ leader key ]] -----------------------------------------------------
g.mapleader = " "
g.maplocalleader = ","
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- [[ multi cursor ]] ---------------------------------------------------
g.multi_cursor_use_default_mapping = 0
g.VM_mouse_mappings = 1

-- [[ which-key settings ]] ---------------------------------------------
wk.setup({ window = { border = "single", position = "bottom" } })

-- [[ copilot settings ]] -----------------------------------------------
g.copilot_no_tab_map = true

local copilot_opts = {
	noremap = true,
	silent = true,
	expr = true,
	replace_keycodes = false,
}

map("i", "<C-l>", [[ copilot#Accept("<CR>") ]], copilot_opts)

-- [[ functions ]] ------------------------------------------------------
local telescope_no_previewer = function(fun)
	fun(telescope.themes.get_dropdown({
		previewer = false,
	}))
end

local buffers = {
	search = function()
		telescope_no_previewer(telescope.builtin.current_buffer_fuzzy_find)
	end,
	list = function()
		telescope_no_previewer(telescope.builtin.buffers)
	end,
	format = function()
		formatters.format({
			timeout_ms = 500,
			lsp_fallback = true,
		})
	end,
}

local git = {
	stage_hunk = function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	reset_hunk = function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end,
	blame_line = function()
		gitsigns.blame_line({ full = true })
	end,
	branches = function()
		telescope_no_previewer(telescope.builtin.git_branches)
	end,
}

local section = function(key, name, prefix, mode)
	wk.register({
		[key] = { name = name },
	}, { prefix = prefix, mode = mode })
end

-- [[ keymaps ]] --------------------------------------------------------
-- remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit mode pressing 'jk'
map("i", "jk", "<ESC>", { noremap = true, silent = true })
map("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

-- resize windows
map("n", "+", "<cmd>resize +2<cr>", { noremap = true, silent = true })
map("n", "-", "<cmd>vertical resize -2<cr>", { noremap = true, silent = true })
map("n", "=", "<cmd>vertical resize +2<cr>", { noremap = true, silent = true })
map("n", "_", "<cmd>resize -2<cr>", { noremap = true, silent = true })

-- quickfix
section("q", "quickfix", "<localleader>", "n")
map("n", "<localleader>qo", "<cmd>copen<cr>", { desc = "Open" })
map("n", "<localleader>qq", "<cmd>cclose<cr>", { desc = "Close" })

-- buffers
section("b", "buffers", "<leader>", "n")
map("n", "<S-h>", "<cmd>bp<cr>", { desc = "Previous" })
map("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next" })
map("n", "<leader>/", buffers.search, { desc = "Search in current buffer" })
map("n", "<leader>bb", buffers.list, { desc = "List buffers" })
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })
map("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })

-- files
section("f", "files", "<leader>", "n")
map("n", "<leader><space>", telescope.builtin.find_files, { desc = "Find files" })
map("n", "<leader>fG", telescope.builtin.git_files, { desc = "Git files" })
map("n", "<leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })

-- git
section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gB", telescope.builtin.git_bcommits, { desc = "Commits (buffer)" })
map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>gb", git.branches, { desc = "Branches" })
map("n", "<leader>gc", telescope.builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
map("n", "<leader>gl", git.blame_line, { desc = "Blame line" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })
map("v", "<leader>gr", git.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>gs", git.stage_hunk, { desc = "Stage hunk" })

-- todos
vim.keymap.set("n", "]t", todos.jump_next, { desc = "Next todo comment" })
vim.keymap.set("n", "[t", todos.jump_prev, { desc = "Previous todo comment" })

-- repl
section("r", "REPL", "<leader>", "n")
map("n", "<space>rs", "<cmd>IronRepl<cr>", { desc = "Open" })
map("n", "<space>rr", "<cmd>IronRestart<cr>", { desc = "Restart" })
map("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus" })
map("n", "<space>rh", "<cmd>IronHide<cr>", { desc = "Hide" })

-- windows
section("w", "windows", "<leader>", "n")
map("n", "<leader>wd", "<C-w>q", { desc = "Close" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>wx", "<C-w>x", { desc = "Swap" })

-- general keymaps
map("n", "<leader>S", "<cmd>Copilot panel<cr>", { desc = "Copilot sugestions" })
map("n", "<leader>c", "<cmd>nohl<cr>", { desc = "Clear highlights" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer (tree)" })
map("n", "<leader>h", telescope.builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>u", telescope.extensions.undo.undo, { desc = "Undo tree" })
map("n", "<leader>z", telescope.extensions.zoxide.list, { desc = "Zoxide" })
map("n", "<localleader>s", telescope.builtin.symbols, { desc = "Symbols" })

-- [[ mini stuff ]] -----------------------------------------------------
-- moving around buffer
jump2d.setup({ mappings = { start_jumping = "<leader>j" } })

-- split and join arguments
splitjoin.setup({ mappings = { toggle = "<leader>t" } })

-- surround text objects
section("s", "surround", "<leader>", { "n", "v" })
surround.setup({
	mappings = {
		add = "<leader>sa", -- add surrounding in normal and visual modes
		delete = "<leader>sd", -- delete surrounding
		find = "<leader>sl", -- find surrounding (to the right)
		find_left = "<leader>sh", -- find surrounding (to the left)
		highlight = "<leader>sH", -- highlight surrounding
		replace = "<leader>sr", -- replace surrounding
		update_n_lines = "<leader>sn", -- update `n_lines`
	},
})

-- move text around
move.setup({
	mappings = {
		-- visual mode
		right = ">",
		left = "<",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_right = ">",
		line_left = "<",
		line_down = "<S-j>",
		line_up = "<S-k>",
	},
})
