-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local g = vim.g
local map = vim.keymap.set

-- [[ imports ]] --------------------------------------------------------
local bufremove = require("mini.bufremove")
local dap = require("dap")
local dap_ui = require("dapui")
local formatters = require("conform")
local gitsigns = require("gitsigns")
local jump2d = require("mini.jump2d")
local move = require("mini.move")
local nabla = require("nabla")
local splitjoin = require("mini.splitjoin")
local surround = require("mini.surround")
local todos = require("todo-comments")
local wk = require("which-key")
local terminal = require("FTerm")

local telescope = {
	builtin = require("telescope.builtin"),
	extensions = require("telescope").extensions,
	themes = require("telescope.themes"),
}

-- [[ augroups ]] -------------------------------------------------------
local ft_group = augroup("UserFiletypeKeymaps", { clear = true })

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
local md_toggle = function()
	local checked_character = "x"
	local checked_checkbox = "%[" .. checked_character .. "%]"
	local unchecked_checkbox = "%[ %]"
	local bufnr = vim.api.nvim_buf_get_number(0)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local start_line = cursor[1] - 1
	local new_line = ""

	local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

	local checkbox = {
		contains_unchecked = function(line)
			return string.find(line, unchecked_checkbox)
		end,
		check = function(line)
			return line:gsub(unchecked_checkbox, checked_checkbox)
		end,
		uncheck = function(line)
			return line:gsub(checked_checkbox, unchecked_checkbox)
		end,
	}

	if checkbox.contains_unchecked(current_line) then
		new_line = checkbox.check(current_line)
	else
		new_line = checkbox.uncheck(current_line)
	end

	vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
	vim.api.nvim_win_set_cursor(0, cursor)
end

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
	ui = terminal:new({
		ft = "lazygit",
		cmd = "lazygit",
		dimensions = {
			height = 0.9,
			width = 0.9,
		},
	}),
}

local section = function(key, name, prefix, mode)
	wk.register({
		[key] = { name = name },
	}, { prefix = prefix, mode = mode })
end

local conditional_breakpoint = function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end

-- [[ keymaps ]] --------------------------------------------------------
-- remap for dealing with word wrap
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- exit mode pressing 'jk'
map("i", "jk", "<ESC>", { noremap = true, silent = true })

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
map("n", "<leader>bd", bufremove.delete, { desc = "Delete" })
map("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
map("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })
map("n", "<leader>bw", bufremove.wipeout, { desc = "Wipeout" })
map("n", "<leader>bo", "<cmd>w <bar> %bd <bar> e# <bar> bd# <cr><cr>", { desc = "Close all other buffers" })
map("n", "<leader><space>", buffers.list, { desc = "List buffers" })
map("n", "<leader>/", buffers.search, { desc = "Search in current buffer" })

-- DAP
map("n", "<F1>", dap.step_over, { desc = "Step over [DAP]" })
map("n", "<F2>", dap.step_into, { desc = "Step into [DAP]" })
map("n", "<F3>", dap.step_back, { desc = "Step back [DAP]" })
map("n", "<F4>", dap.step_out, { desc = "Step out [DAP]" })
map("n", "<F5>", dap.continue, { desc = "Continue [DAP]" })

map("v", "<localleader>e", dap_ui.eval, { desc = "Evaluate [DAP]" })

section("d", "DAP", "<leader>", "n")
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", conditional_breakpoint, { desc = "Conditional breakpoint" })
map("n", "<leader>dp", dap.pause, { desc = "Pause" })
map("n", "<leader>dq", dap.close, { desc = "Quit" })
map("n", "<leader>dt", dap_ui.toggle, { desc = "See last session result" })

section("dl", "list", "<leader>", "n")
map("n", "<leader>dlv", telescope.extensions.dap.variables, { desc = "Variables" })
map("n", "<leader>dlb", telescope.extensions.dap.list_breakpoints, { desc = "Breakpoints" })

-- files
section("f", "files", "<leader>", "n")
map("n", "<leader>ff", telescope.builtin.find_files, { desc = "Find all files" })
map("n", "<leader>fg", telescope.builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Search TODOs" })
map("n", "<leader>fG", telescope.builtin.git_files, { desc = "Git files" })

-- git
section("g", "git", "<leader>", { "n", "v" })
map("n", "<leader>gB", telescope.builtin.git_bcommits, { desc = "Commits (buffer)" })
map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset buffer" })
map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage buffer" })
map("n", "<leader>gb", git.branches, { desc = "Branches" })
map("n", "<leader>gc", telescope.builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff this" })
map("n", "<leader>gl", git.blame_line, { desc = "Blame line" })
map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview hunk" })
map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset hunk" })
map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage hunk" })
map("n", "<leader>gt", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
map("v", "<leader>gr", git.reset_hunk, { desc = "Reset hunk" })
map("v", "<leader>gs", git.stage_hunk, { desc = "Stage hunk" })
map("n", "]h", gitsigns.next_hunk, { desc = "Next hunk" })
map("n", "[h", gitsigns.prev_hunk, { desc = "Previous hunk" })

map("n", "<leader>gg", function()
	git.ui:toggle()
end, { desc = "Lazygit" })

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
map("n", "<leader>wn", "<C-w>w", { desc = "Next" })
map("n", "<leader>wp", "<C-w>p", { desc = "Previous" })
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

-- markdown/quarto
autocmd("FileType", {
	pattern = "markdown",
	group = ft_group,
	callback = function()
		map({ "n", "i" }, "<C-b>", telescope.extensions.bibtex.bibtex, { desc = "Insert reference" })
		map("n", "<localleader>e", nabla.toggle_virt, { desc = "Toggle equation preview" })
		map("n", "<localleader>x", md_toggle, { desc = "Toggle check" })
	end,
})

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
		left = "<S-h>",
		right = "<S-l>",
		down = "<S-j>",
		up = "<S-k>",
		-- normal mode
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_down = "<S-j>",
		line_up = "<S-k>",
	},
})
