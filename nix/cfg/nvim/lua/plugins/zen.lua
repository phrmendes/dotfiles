local zen = require("zen-mode")

zen.setup({
    plugins = {
        gitsigns = { enabled = true }, -- disables git signs
        tmux = { enabled = true }, -- disables the tmux statusline
        wezterm = {
            enabled = false,
            font = "+4",
        },
    },
})
