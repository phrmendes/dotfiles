local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local parse_snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, { wordTrig = true })
local today = os.date("%Y-%m-%d")

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup({ enable_autosnippets = true })
vscode_loaders.lazy_load()

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
	parse_snippet({ trig = "!=", name = "not equals", regTrig = true }, "\\neq "),
	parse_snippet({ trig = "**", name = "cdot", regTrig = true }, "\\cdot "),
	parse_snippet({ trig = "+-", name = "+-", regTrig = true }, "\\pm"),
	parse_snippet({ trig = "->", name = "to", regTrig = true }, "\\to "),
	parse_snippet({ trig = ":=", name = "definition", regTrig = true }, "\\coloneqq "),
	parse_snippet({ trig = "<->", name = "left and right arrow", regTrig = true }, "\\leftrightarrow"),
	parse_snippet({ trig = "<<", name = "<<", regTrig = true }, "\\ll"),
	parse_snippet({ trig = "<=", name = "less than or equal", regTrig = true }, "\\leq "),
	parse_snippet({ trig = "<==", name = "implied by", regTrig = true }, "\\impliedby"),
	parse_snippet({ trig = "<=>", name = "iff", regTrig = true }, "\\iff"),
	parse_snippet({ trig = "==>", name = "implies", regTrig = true }, "\\implies"),
	parse_snippet({ trig = ">=", name = "greater than or equal", regTrig = true }, "\\geq "),
	parse_snippet({ trig = ">>", name = ">>", regTrig = true }, "\\gg"),
	parse_snippet({ trig = "__", name = "subscript", regTrig = true }, "_{$1}$0"),
	parse_snippet({ trig = "bar", name = "bar", regTrig = true }, "\\overline{$1}$0"),
	parse_snippet({ trig = "bcap", name = "bigcap", regTrig = true }, "\\bigcap_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "bcup", name = "bigcup", regTrig = true }, "\\bigcup_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "cancel", name = "cancel", regTrig = true }, "\\cancel{$1}$0"),
	parse_snippet({ trig = "cap", name = "intersection", regTrig = true }, "\\cap "),
	parse_snippet({ trig = "compl", name = "complement", regTrig = true }, "^{c}"),
	parse_snippet({ trig = "cube", name = "cube ^3", regTrig = true }, "^3 "),
	parse_snippet({ trig = "cup", name = "union", regTrig = true }, "\\cup "),
	parse_snippet({ trig = "deriv", name = "derivative", regTrig = true }, "\\frac{d${1:F}}{d${2:x}} $0"),
	parse_snippet({ trig = "dots", name = "dots", regTrig = true }, "\\dots "),
	parse_snippet({ trig = "empty", name = "emptyset", regTrig = true }, "\\emptyset"),
	parse_snippet({ trig = "ext", name = "exists", regTrig = true }, "\\exists "),
	parse_snippet({ trig = "forall", name = "for all", regTrig = true }, "\\forall "),
	parse_snippet({ trig = "frac", name = "fraction", regTrig = true }, "\\frac{$1}{$2}$0"),
	parse_snippet({ trig = "imath", name = "inline math", regTrig = true }, "$${1:equation}$"),
	parse_snippet({ trig = "inf", name = "\\infty", regTrig = true }, "\\infty"),
	parse_snippet(
		{ trig = "int", name = "integral", regTrig = true },
		"\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:F} $0"
	),
	parse_snippet({ trig = "invs", name = "inverse", regTrig = true }, "^{-1}"),
	parse_snippet({ trig = "lim", name = "limit", regTrig = true }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "liminf", name = "liminf", regTrig = true }, "\\liminf_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "limsup", name = "limsup", regTrig = true }, "\\limsup_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet(
		{ trig = "lr(", name = "left( right)", regTrig = true },
		"\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"
	),
	parse_snippet(
		{ trig = "lr<", name = "left< right>", regTrig = true },
		"\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"
	),
	parse_snippet(
		{ trig = "lr[", name = "left[ right]", regTrig = true },
		"\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"
	),
	parse_snippet(
		{ trig = "lr{", name = "left{ right}", regTrig = true },
		"\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"
	),
	parse_snippet(
		{ trig = "lr|", name = "left| right|", regTrig = true },
		"\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"
	),
	parse_snippet({ trig = "math", name = "block math", regTrig = true }, "$$${1:equation}$$"),
	parse_snippet({ trig = "mbb", name = "mathbb", regTrig = true }, "\\mathbb{$1}$0"),
	parse_snippet({ trig = "mcal", name = "mathcal", regTrig = true }, "\\mathcal{$1}$0"),
	parse_snippet({ trig = "mean", name = "sample mean", regTrig = true }, "\\bar{X}"),
	parse_snippet({ trig = "nabl", name = "nabla", regTrig = true }, "\\nabla "),
	parse_snippet({ trig = "norm", name = "norm", regTrig = true }, "\\|$1\\|$0"),
	parse_snippet({ trig = "notin", name = "not in ", regTrig = true }, "\\not\\in "),
	parse_snippet({ trig = "over", name = "a/b", regTrig = true }, "{$1 \\over $2} $0"),
	parse_snippet(
		{ trig = "pderiv", name = "partial derivative", regTrig = true },
		"\\frac{\\partial ${1:F}}{\\partial ${2:x}} $0"
	),
	parse_snippet({ trig = "pow", name = "to the ... power ^{}", regTrig = true }, "^{$1}$0 "),
	parse_snippet(
		{ trig = "prod", name = "product", regTrig = true },
		"\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:F} $0"
	),
	parse_snippet({ trig = "set", name = "set", regTrig = true }, "\\{$1\\} $0"),
	parse_snippet({ trig = "sqr", name = "square ^2", regTrig = true }, "^2"),
	parse_snippet({ trig = "ss", name = "subset", regTrig = true }, "\\subset "),
	parse_snippet({ trig = "stt", name = "text subscript", regTrig = true }, "_\\text{$1} $0"),
	parse_snippet({ trig = "sum", name = "sum", regTrig = true }, "\\sum_{n=${1:1}}^{${2:\\infty}} ${3:a_n z^n}"),
	parse_snippet(
		{ trig = "taylor", name = "taylor", regTrig = true },
		"\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"
	),
	parse_snippet({ trig = "text", name = "text", regTrig = true }, "\\text{$1}$0"),
	parse_snippet({ trig = "tt", name = "text", regTrig = true }, "\\text{$1}$0"),
	parse_snippet({ trig = "x", name = "times", regTrig = true }, "\\times "),
	parse_snippet({ trig = "xii", name = "xi", regTrig = true }, "x_{i}"),
	parse_snippet({ trig = "xjj", name = "xj", regTrig = true }, "x_{j}"),
	parse_snippet({ trig = "xmm", name = "x", regTrig = true }, "x_{m}"),
	parse_snippet({ trig = "xnn", name = "xn", regTrig = true }, "x_{n}"),
	parse_snippet({ trig = "xp1", name = "x", regTrig = true }, "x_{n+1}"),
	parse_snippet({ trig = "xx", name = "cross", regTrig = true }, "\\times "),
	parse_snippet({ trig = "yii", name = "yi", regTrig = true }, "y_{i}"),
	parse_snippet({ trig = "yjj", name = "yj", regTrig = true }, "y_{j}"),
	parse_snippet({ trig = "ynn", name = "yn", regTrig = true }, "y_{n}"),
	parse_snippet({ trig = "|->", name = "mapsto", regTrig = true }, "\\mapsto "),
	parse_snippet({ trig = "||", name = "mid", regTrig = true }, " \\mid "),
	parse_snippet({ trig = "~=", name = "approx", regTrig = true }, "\\approx "),
	parse_snippet({ trig = "~~", name = "~", regTrig = true }, "\\sim "),
}

luasnip.add_snippets("markdown", markdown_snippets)
luasnip.add_snippets("markdown", equation_snippets)
