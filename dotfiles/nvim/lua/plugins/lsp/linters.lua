require("lint").linters_by_ft = {
	dockerfile = { "hadolint" },
	go = { "golangcilint" },
	jinja = { "djlint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	template = { "djlint" },
	terraform = { "tflint" },
}
