local org_dir = vim.env.NOTES_DIR .. "/org"
local template = {}

template.todo = [[** TODO %?]]

template.scheduled = [[
* TODO %?
  SCHEDULED: %t
]]

template.deadline = [[
* TODO %?
  DEADLINE: %t
]]

template.event = [[
** %?
   SCHEDULED: %T
]]

template.calendar = [[
** %?
   %t
]]

require("orgmode").setup({
	org_agenda_files = { org_dir .. "/**/*" },
	org_archive_location = org_dir .. "/archive.org",
	org_default_notes_file = org_dir .. "/inbox.org",
	org_todo_keywords = { "TODO(t)", "NEXT(n)", "|", "DONE(d)" },
	calendar_week_start_day = 0,
	org_deadline_warning_days = 7,
	org_tags_column = 0,
	org_ellipsis = " ▼",
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
			org_agenda = { "<localleader>a" },
			org_capture = { "<localleader>c" },
		},
	},
	org_capture_templates = {
		t = "Task",
		e = "Event",
		tt = {
			description = "Default",
			template = template.todo,
			target = org_dir .. "/tasks.org",
			properties = { empty_lines = { before = 1 } },
		},
		ts = {
			description = "Scheduled",
			template = template.scheduled,
			target = org_dir .. "/tasks.org",
			properties = { empty_lines = { before = 1 } },
		},
		td = {
			description = "Deadline",
			template = template.deadline,
			target = org_dir .. "/tasks.org",
			properties = { empty_lines = { before = 1 } },
		},
		ee = {
			description = "Default",
			template = template.event,
			target = org_dir .. "/agenda.org",
			properties = { empty_lines = { before = 1 } },
			headline = "One-time",
		},
		er = {
			description = "Recurrent",
			template = template.event,
			target = org_dir .. "/agenda.org",
			properties = { empty_lines = { before = 1 } },
			headline = "Recurrent",
		},
		ec = {
			description = "Calendar",
			template = template.calendar,
			target = org_dir .. "/agenda.org",
			properties = { empty_lines = { before = 1 } },
			headline = "Calendar",
		},
	},
})
