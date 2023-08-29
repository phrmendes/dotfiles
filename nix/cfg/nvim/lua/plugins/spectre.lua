local spectre = require("spectre")

spectre.setup({
    mapping = {
        ["toggle_line"] = {
            map = "dd",
            cmd = function()
                require("spectre").toggle_line()
            end,
            desc = "Spectre - Toggle current item",
        },
        ["enter_file"] = {
            map = "<cr>",
            cmd = function()
                require("spectre.actions").select_entry()
            end,
            desc = "Spectre - Goto current file",
        },
        ["send_to_qf"] = {
            map = "<leader>q",
            cmd = function()
                require("spectre.actions").send_to_qf()
            end,
            desc = "Spectre - Send all item to quickfix",
        },
        ["replace_cmd"] = {
            map = "<leader>c",
            cmd = function()
                require("spectre.actions").replace_cmd()
            end,
            desc = "Spectre - Input replace vim command",
        },
        ["show_option_menu"] = {
            map = "<leader>o",
            cmd = function()
                require("spectre").show_options()
            end,
            desc = "Spectre - Show option",
        },
        ["run_current_replace"] = {
            map = "<leader>rc",
            cmd = function()
                require("spectre.actions").run_current_replace()
            end,
            desc = "Spectre - Replace current line",
        },
        ["run_replace"] = {
            map = "<leader>R",
            cmd = function()
                require("spectre.actions").run_replace()
            end,
            desc = "Spectre - Replace all",
        },
        ["change_view_mode"] = {
            map = "<leader>v",
            cmd = function()
                require("spectre").change_view()
            end,
            desc = "Spectre - Change result view mode",
        },
        ["change_replace_sed"] = {
            map = "trs",
            cmd = function()
                require("spectre").change_engine_replace("sed")
            end,
            desc = "Spectre - Use sed to replace",
        },
        ["change_replace_oxi"] = {
            map = "tro",
            cmd = function()
                require("spectre").change_engine_replace("oxi")
            end,
            desc = "Spectre - Use oxi to replace",
        },
        ["toggle_live_update"] = {
            map = "tu",
            cmd = function()
                require("spectre").toggle_live_update()
            end,
            desc = "Spectre - Update change when vim write file.",
        },
        ["toggle_ignore_case"] = {
            map = "ti",
            cmd = function()
                require("spectre").change_options("ignore-case")
            end,
            desc = "Spectre - Toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
            map = "th",
            cmd = function()
                require("spectre").change_options("hidden")
            end,
            desc = "Spectre - Toggle search hidden",
        },
        ["resume_last_search"] = {
            map = "<leader>l",
            cmd = function()
                require("spectre").resume_last_search()
            end,
            desc = "Spectre - Resume last search before close",
        },
    },
})
