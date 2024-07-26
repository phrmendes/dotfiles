require("lint").linters_by_ft = {
	dockerfile = { "hadolint" },
	go = { "golangcilint" },
	jinja = { "djlint" },
	sh = { "shellcheck" },
	template = { "djlint" },
	terraform = { "tflint" },
}
