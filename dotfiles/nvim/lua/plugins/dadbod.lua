return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_dotenv_variable_prefix = "DADBOD_"
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_use_nvim_notify = 1
		vim.g.db_ui_table_helpers = {
			mongodb = {
				Aggregate = "{table}.aggregate([])",
				Count = "{table}.countDocuments()",
				Distinct = "{table}.distinct()",
				EstimatedDocumentCount = "{table}.estimatedDocumentCount()",
				FindOne = "{table}.findOne()",
				Insert = "{table}.insertOne()",
				InsertMany = "{table}.insertMany([])",
				MapReduce = "{table}.mapReduce()",
			},
		}
	end,
}
