require("lint").linters_by_ft = {
	dockerfile = { "hadolint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	terraform = { "tflint" },
}
