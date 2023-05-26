local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local themes_setup, themes = pcall(require, "telescope.themes")
if not themes_setup then
	return
end

telescope.setup({
	pickers = {
		live_grep = {
			additional_args = function(opts)
				return { "--hidden" }
			end,
		},
	},
	defaults = {
		hidden = true,
		mappings = {
			i = {
				["<C-p>"] = actions.move_selection_previous, -- move to prev result
				["<C-n>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
	extensions = {
		["ui-select"] = {
			themes.get_dropdown({}),
		},
		["repo"] = {
			list = {
				search_dirs = { "~/Projects" },
			},
		},
	},
})

telescope.load_extension("bibtex")
telescope.load_extension("fzf")
telescope.load_extension("projects")
telescope.load_extension("repo")
telescope.load_extension("ui-select")
