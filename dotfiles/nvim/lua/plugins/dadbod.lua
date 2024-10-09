vim.g.db_ui_env_variable_url = "DB_URL"
vim.g.db_ui_env_variable_name = "DB_NAME"
vim.g.db_ui_use_nvim_notify = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_table_helpers = {
	mongodb = {
		Aggregate = "{table}.aggregate([])",
		Count = "{table}.countDocuments()",
		Distinct = "{table}.distinct()",
		EstimatedDocumentCount = "{table}.estimatedDocumentCount()",
		Find = "{table}.find()",
		FindOne = "{table}.findOne()",
		Insert = "{table}.insertOne()",
		InsertMany = "{table}.insertMany([])",
		MapReduce = "{table}.mapReduce()",
	},
}
