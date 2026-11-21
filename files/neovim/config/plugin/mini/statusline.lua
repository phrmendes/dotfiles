safely("now", function()
  local st = require("mini.statusline")

  st.setup()

  local old = st.section_git
  local max_len = 20

  st.section_git = function(args)
    local git = old(args)
    local session = require("nsm").current()
    if session and vim.fn.strchars(session) > max_len then session = vim.fn.strcharpart(session, 0, max_len - 1) .. "…" end
    local label = session and (" " .. session) or ""
    return vim.trim(label .. " " .. git)
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable statusline in sidekick terminal",
  pattern = "sidekick_terminal",
  callback = function(event) vim.b[event.buf].ministatusline_disable = true end,
})
