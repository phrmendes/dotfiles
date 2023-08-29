local spectre = require("spectre")

spectre.setup({
    mapping = {
        ["toggle_line"] = {
            map = "dd",
            cmd = "<cmd>lua require('spectre').toggle_line()<cr>",
            desc = "Spectre - Toggle current item",
        },
        ["enter_file"] = {
            map = "<cr>",
            cmd = "<cmd>lua require('spectre.actions').select_entry()<cr>",
            desc = "Spectre - Goto current file",
        },
        ["send_to_qf"] = {
            map = "<leader>q",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<cr>",
            desc = "Spectre - Send all item to quickfix",
        },
        ["replace_cmd"] = {
            map = "<leader>c",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<cr>",
            desc = "Spectre - Input replace vim command",
        },
        ["show_option_menu"] = {
            map = "<leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<cr>",
            desc = "Spectre - Show option",
        },
        ["run_current_replace"] = {
            map = "<leader>rc",
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<cr>",
            desc = "Spectre - Replace current line",
        },
        ["run_replace"] = {
            map = "<leader>R",
            cmd = "<cmd>lua require('spectre.actions').run_replace()<cr>",
            desc = "Spectre - Replace all",
        },
        ["change_view_mode"] = {
            map = "<leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<cr>",
            desc = "Spectre - Change result view mode",
        },
        ["change_replace_sed"] = {
            map = "trs",
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<cr>",
            desc = "Spectre - Use sed to replace",
        },
        ["change_replace_oxi"] = {
            map = "tro",
            cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<cr>",
            desc = "Spectre - Use oxi to replace",
        },
        ["toggle_live_update"] = {
            map = "tu",
            cmd = "<cmd>lua require('spectre').toggle_live_update()<cr>",
            desc = "Spectre - Update change when vim write file.",
        },
        ["toggle_ignore_case"] = {
            map = "ti",
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<cr>",
            desc = "Spectre - Toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
            map = "th",
            cmd = "<cmd>lua require('spectre').change_options('hidden')<cr>",
            desc = "Spectre - Toggle search hidden",
        },
        ["resume_last_search"] = {
            map = "<leader>l",
            cmd = "<cmd>lua require('spectre').resume_last_search()<cr>",
            desc = "Spectre - Resume last search before close",
        },
    },
})
