local orgmode = require("orgmode")
local notes = os.getenv("NOTES_DIR") or os.getenv("HOME") .. "/Documents/notes"

orgmode.setup_ts_grammar()

orgmode.setup({
	org_agenda_files = { notes .. "/agenda/*" },
	org_default_notes_file = notes .. "/index.org",
	org_todo_keywords = { "TODO(t)", "NEXT(n)", "|", "DONE(d)", "CANCELLED(c)" },
	win_split_mode = { "float", "0.75" },
    calendar_week_start_day = 0,
    org_agenda_start_on_weekday = 0,
    org_archive_location = notes .. "archive.org",
    mappings = {
        global = {
            org_agenda = "<leader>oa",
            org_capture = "<leader>oc",
        },
    },
})
