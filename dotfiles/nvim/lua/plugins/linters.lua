require("lint").linters_by_ft = {
	dockerfile = { "hadolint" },
	go = { "golangcilint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	terraform = { "tflint" },
}
