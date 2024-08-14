require("lint").linters_by_ft = {
	dockerfile = { "hadolint" },
	nix = { "deadnix" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	terraform = { "tflint" },
}
