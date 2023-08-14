local treesitter = require("nvim-treesitter.configs")
local context = require("treesitter-context")

treesitter.setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
    indent = { enable = true },
    autotag = { enable = true },
})

context.setup()
