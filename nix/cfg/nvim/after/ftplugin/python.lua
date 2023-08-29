local wk = require("which-key")

local leader = {
    normal = {
        options = {
            mode = "n",
            prefix = "<leader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            d = {
                name = "+debugger",
                P = {
                    name = "+python",
                    c = {
                        function()
                            require("dap-python").test_class()
                        end,
                        "Test class",
                    },
                    m = {
                        function()
                            require("dap-python").test_method()
                        end,
                        "Test method",
                    },
                },
            },
        },
    },
    visual = {
        options = {
            mode = "v",
            prefix = "<leader>",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = false,
        },
        mappings = {
            p = {
                function()
                    require("dap-python").debug_selection()
                end,
                "DAP - Debug python region",
            },
        },
    },
}

wk.register(leader.normal.mappings, leader.normal.options)
wk.register(leader.visual.mappings, leader.visual.options)
