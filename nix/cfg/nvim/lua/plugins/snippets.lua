local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")

local parse_snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, { wordTrig = true })
local today = os.date("%Y-%m-%d")
local map = vim.keymap.set

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup({ enable_autosnippets = true })
vscode_loaders.lazy_load()

map({ "i", "s" }, "<C-k>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(-1)
	end
end, { desc = "Snippets: Previous choice" })

map({ "i", "s" }, "<C-j>", function()
	if luasnip.choice_active() then
		return luasnip.change_choice(1)
	end
end, { desc = "Snippets: Next choice" })

-- [[ snippets ]] --------------------------------------------------------
local markdown_snippets = {
	parse_snippet({ trig = "journal", name = "journal" }, "# " .. today .. "\n"),
	parse_snippet({ trig = "metadata", name = "metadata" }, "\n---\naliases: [{$1}]\ntags: [{$2}]\n---\n$0"),
	parse_snippet({ trig = "todo", name = "TODO" }, "- [ ] @TODO $0"),
	parse_snippet({ trig = "due", name = "due" }, " 📅 $0"),
	parse_snippet({ trig = "scheduled", name = "scheduled" }, " ⌛ $0"),
	parse_snippet({ trig = "done", name = "done" }, " ✅ " .. today .. " $0"),
	parse_snippet({ trig = "low", name = "low priority" }, " 🔽"),
	parse_snippet({ trig = "medium", name = "medium priority" }, " 🔼"),
	parse_snippet({ trig = "high", name = "high priority" }, " ⏫"),
}

local equation_snippets = {
	parse_snippet({ trig = "!=", name = "not equals" }, "\\neq "),
	parse_snippet({ trig = "**", name = "cdot" }, "\\cdot "),
	parse_snippet({ trig = "+-", name = "+-" }, "\\pm"),
	parse_snippet({ trig = "->", name = "to" }, "\\to "),
	parse_snippet({ trig = ":=", name = "definition" }, "\\coloneqq "),
	parse_snippet({ trig = "<->", name = "left and right arrow" }, "\\leftrightarrow"),
	parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),
	parse_snippet({ trig = "<=", name = "less than or equal" }, "\\leq "),
	parse_snippet({ trig = "<==", name = "implied by" }, "\\impliedby"),
	parse_snippet({ trig = "<=>", name = "iff" }, "\\iff"),
	parse_snippet({ trig = "==>", name = "implies" }, "\\implies"),
	parse_snippet({ trig = ">=", name = "greater than or equal" }, "\\geq "),
	parse_snippet({ trig = ">>", name = ">>" }, "\\gg"),
	parse_snippet({ trig = "__", name = "subscript" }, "_{$1}$0"),
	parse_snippet({ trig = "bar", name = "bar" }, "\\overline{$1}$0"),
	parse_snippet({ trig = "bcap", name = "bigcap" }, "\\bigcap_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "bcup", name = "bigcup" }, "\\bigcup_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "cancel", name = "cancel" }, "\\cancel{$1}$0"),
	parse_snippet({ trig = "cap", name = "intersection" }, "\\cap "),
	parse_snippet({ trig = "compl", name = "complement" }, "^{c}"),
	parse_snippet({ trig = "cube", name = "cube ^3" }, "^3 "),
	parse_snippet({ trig = "cup", name = "union" }, "\\cup "),
	parse_snippet({ trig = "deriv", name = "derivative" }, "\\frac{d${1:F}}{d${2:x}} $0"),
	parse_snippet({ trig = "dots", name = "dots" }, "\\dots "),
	parse_snippet({ trig = "empty", name = "emptyset" }, "\\emptyset"),
	parse_snippet({ trig = "ext", name = "exists" }, "\\exists "),
	parse_snippet({ trig = "forall", name = "for all" }, "\\forall "),
	parse_snippet({ trig = "frac", name = "fraction" }, "\\frac{$1}{$2}$0"),
	parse_snippet({ trig = "imath", name = "inline math" }, "$${1:equation}$"),
	parse_snippet({ trig = "inf", name = "\\infty" }, "\\infty"),
	parse_snippet({ trig = "int", name = "integral" }, "\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:F} $0"),
	parse_snippet({ trig = "invs", name = "inverse" }, "^{-1}"),
	parse_snippet({ trig = "lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "liminf", name = "liminf" }, "\\liminf_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "limsup", name = "limsup" }, "\\limsup_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "lr(", name = "left( right)" }, "\\left( $1 \\right) $0"),
	parse_snippet({ trig = "lr<", name = "left< right>" }, "\\left< $1 \\right>$0"),
	parse_snippet({ trig = "lr[", name = "left[ right]" }, "\\left[ $1 \\right] $0"),
	parse_snippet({ trig = "lr{", name = "left{ right}" }, "\\left\\{ $1 \\right\\\\} $0"),
	parse_snippet({ trig = "lr|", name = "left| right|" }, "\\left| $1 \\right| $0"),
	parse_snippet({ trig = "math", name = "block math" }, "$$${1:equation}$$"),
	parse_snippet({ trig = "mbb", name = "mathbb" }, "\\mathbb{$1}$0"),
	parse_snippet({ trig = "mcal", name = "mathcal" }, "\\mathcal{$1}$0"),
	parse_snippet({ trig = "mean", name = "sample mean" }, "\\bar{X}"),
	parse_snippet({ trig = "nabl", name = "nabla" }, "\\nabla "),
	parse_snippet({ trig = "norm", name = "norm" }, "\\|$1\\|$0"),
	parse_snippet({ trig = "notin", name = "not in " }, "\\not\\in "),
	parse_snippet({ trig = "over", name = "a/b" }, "{$1 \\over $2} $0"),
	parse_snippet({ trig = "pderiv", name = "partial derivative" }, "\\frac{\\partial ${1:F}}{\\partial ${2:x}} $0"),
	parse_snippet({ trig = "pow", name = "to the ... power ^{}" }, "^{$1}$0 "),
	parse_snippet({ trig = "prod", name = "product" }, "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:F} $0"),
	parse_snippet({ trig = "set", name = "set" }, "\\{$1\\} $0"),
	parse_snippet({ trig = "sqr", name = "square ^2" }, "^2"),
	parse_snippet({ trig = "ss", name = "subset" }, "\\subset "),
	parse_snippet({ trig = "stt", name = "text subscript" }, "_\\text{$1} $0"),
	parse_snippet({ trig = "sum", name = "sum" }, "\\sum_{n=${1:1}}^{${2:\\infty}} ${3:a_n z^n}"),
	parse_snippet({ trig = "taylor", name = "taylor" }, "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"),
	parse_snippet({ trig = "text", name = "text" }, "\\text{$1}$0"),
	parse_snippet({ trig = "tt", name = "text" }, "\\text{$1}$0"),
	parse_snippet({ trig = "x", name = "times" }, "\\times "),
	parse_snippet({ trig = "xii", name = "xi" }, "x_{i}"),
	parse_snippet({ trig = "xjj", name = "xj" }, "x_{j}"),
	parse_snippet({ trig = "xmm", name = "x" }, "x_{m}"),
	parse_snippet({ trig = "xnn", name = "xn" }, "x_{n}"),
	parse_snippet({ trig = "xp1", name = "x" }, "x_{n+1}"),
	parse_snippet({ trig = "xx", name = "cross" }, "\\times "),
	parse_snippet({ trig = "yii", name = "yi" }, "y_{i}"),
	parse_snippet({ trig = "yjj", name = "yj" }, "y_{j}"),
	parse_snippet({ trig = "ynn", name = "yn" }, "y_{n}"),
	parse_snippet({ trig = "|->", name = "mapsto" }, "\\mapsto "),
	parse_snippet({ trig = "||", name = "mid" }, " \\mid "),
	parse_snippet({ trig = "~=", name = "approx" }, "\\approx "),
	parse_snippet({ trig = "~~", name = "~" }, "\\sim "),
}

luasnip.add_snippets("markdown", markdown_snippets)
luasnip.add_snippets("markdown", equation_snippets)
