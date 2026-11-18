safely("now", function()
  local st = require("mini.statusline")

  st.setup()

  local backup = st.section_git

  st.section_git = function(args)
    local git = backup(args)
    local session = require("nsm").current()
    local label = session and (" " .. session) or ""
    return vim.trim(label .. " " .. git)
  end
end)
