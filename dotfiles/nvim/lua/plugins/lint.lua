require("lint").linters_by_ft = {
	htmldjango = { "djlint" },
	jinja2 = { "djlint" },
	dockerfile = { "hadolint" },
	terraform = { "tflint" },
	go = { "golangcilint" },
	sql = { "sqruff" },
}
