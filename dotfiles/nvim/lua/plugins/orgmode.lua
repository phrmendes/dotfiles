local org_dir = vim.env.NOTES_DIR .. "/org"
local template = {}

template.todo = [[** TODO %?]]

template.todo_scheduled = [[
	** TODO %?
	   SCHEDULED: %t
]]

template.todo_deadline = [[
	** TODO %?
	   DEADLINE: %t
]]

template.event = [[
	** %?
	   %T
]]

template.event_scheduled = [[
	** %?
	   SCHEDULED: %t
]]

require("orgmode").setup({
	org_agenda_files = { org_dir .. "/**/*" },
	org_archive_location = { org_dir .. "/archive.org::" },
	org_todo_keywords = { "TODO(t)", "NEXT(n)", "|", "DONE(d)" },
	calendar_week_start_day = 0,
	org_deadline_warning_days = 7,
	org_ellipsis = "▼",
	notifications = {
		enabled = true,
		cron_enabled = false,
		reminder_time = { 1, 30 },
		deadline_reminder = true,
		scheduled_reminder = true,
	},
	mappings = {
		org_return_uses_meta_return = true,
		prefix = "go",
		global = {
			org_agenda = { "gA" },
			org_capture = { "gC" },
		},
	},
	org_capture_templates = {
		t = "TODO",
		e = "Event",
		tt = {
			description = "Default",
			template = template.todo,
			target = org_dir .. "/todo.org",
			properties = { empty_lines = { after = 1 } },
		},
		ts = {
			description = "Scheduled",
			template = template.todo_scheduled,
			target = org_dir .. "/todo.org",
			properties = { empty_lines = { after = 1 } },
		},
		td = {
			description = "Deadline",
			template = template.todo_deadline,
			target = org_dir .. "/todo.org",
			properties = { empty_lines = { after = 1 } },
		},
		ee = {
			description = "Default",
			template = template.event,
			target = org_dir .. "/agenda.org",
			properties = { empty_lines = { after = 1 } },
		},
		es = {
			description = "Scheduled",
			template = template.event_scheduled,
			target = org_dir .. "/agenda.org",
			properties = { empty_lines = { after = 1 } },
		},
	},
})
