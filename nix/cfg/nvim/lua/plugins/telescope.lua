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
    defaults = {
        hidden = true,
        mappings = {
            i = {
                ["<C-Q>"] = actions.send_selection_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                ["<C-n>"] = actions.move_selection_next,            -- move to next result
                ["<C-p>"] = actions.move_selection_previous,        -- move to prev result
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist, -- send selected to quickfixlist
            },
        },
    },
    extensions = {
        ["ui-select"] = { themes.get_dropdown() },
        ["fzy_native"] = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})

telescope.load_extension("bibtex")
telescope.load_extension("fzy_native")
telescope.load_extension("ui-select")
