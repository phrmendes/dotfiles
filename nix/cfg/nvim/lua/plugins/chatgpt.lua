local chatgpt = require("chatgpt")

chatgpt.setup({
    keymaps = {
        scroll_up = "<C-p>",
        scroll_down = "<C-n>",
        new_session = "<C-N>",
        cycle_windows = "<Tab>",
    },
})
