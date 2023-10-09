-- [[ imports ]] --------------------------------------------------------
local luasnip = require("luasnip")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local parse_snippet = luasnip.extend_decorator.apply(luasnip.parser.parse_snippet, {
	wordTrig = true,
})

-- [[ luasnip settings ]] -----------------------------------------------
luasnip.config.setup({ enable_autosnippets = true })
vscode_loaders.lazy_load()

-- [[ snippets ]] --------------------------------------------------------
local markdown_snippets = {
	parse_snippet({ trig = "journal", name = "journal" }, "# " .. os.date("%a, %d %b %Y") .. "\n"),
	parse_snippet({ trig = "metadata", name = "metadata" }, "\n---\naliases: [{$1}]\ntags: [{$2}]\n---\n$0"),
}

-- stylua: ignore start
local equation_snippets = {
	parse_snippet({ trig = "#AA", name = "forall" }, "\\forall "),
	parse_snippet({ trig = "#DD", name = "D" }, "\\mathbb{D}"),
	parse_snippet({ trig = "#EE", name = "exists" }, "\\exists "),
	parse_snippet({ trig = "#HH", name = "H" }, "\\mathbb{H}"),
	parse_snippet({ trig = "#NN", name = "n" }, "\\mathbb{N}"),
	parse_snippet({ trig = "#Nn", name = "cap" }, "\\cap "),
	parse_snippet({ trig = "#OO", name = "emptyset" }, "\\O"),
	parse_snippet({ trig = "#QQ", name = "Q" }, "\\mathbb{Q}"),
	parse_snippet({ trig = "#R0+", name = "R0+" }, "\\mathbb{R}_0^+"),
	parse_snippet({ trig = "#RR", name = "R" }, "\\mathbb{R}"),
	parse_snippet({ trig = "#UU", name = "cup" }, "\\cup "),
	parse_snippet({ trig = "#ZZ", name = "Z" }, "\\mathbb{Z}"),
	parse_snippet({ trig = "#bmat", name = "bmat" }, "\\begin{bmatrix} $1 \\end{bmatrix} $0"),
	parse_snippet({ trig = "#cb", name = "Cube ^3" }, "^3 "),
	parse_snippet({ trig = "#cc", name = "subset" }, "\\subset "),
	parse_snippet({ trig = "#ceil", name = "ceil" }, "\\left\\lceil $1 \\right\\rceil $0"),
	parse_snippet({ trig = "#compl", name = "complement" }, "^{c}"),
	parse_snippet({ trig = "#conj", name = "conjugate" }, "\\overline{$1}$0"),
	parse_snippet({ trig = "#cvec", name = "column vector" }, "\\begin{pmatrix} ${1:x}_${2:1}\\\\ \\vdots\\\\ $1_${2:n} \\end{pmatrix}"),
	parse_snippet({ trig = "#ddx", name = "d/dx" }, "\\frac{\\mathrm{d/${1:V}}}{\\mathrm{d${2:x}}} $0"),
	parse_snippet({ trig = "#dint", name = "integral", priority = 300}, "\\int_{${1:-\\infty}}^{${2:\\infty}} ${3:${TM_SELECTED_TEXT}} $0"),
	parse_snippet({ trig = "#floor", name = "floor" }, "\\left\\lfloor $1 \\right\\rfloor$0"),
	parse_snippet({ trig = "#iff", name = "iff" }, "\\iff"),
	parse_snippet({ trig = "#invs", name = "inverse" }, "^{-1}"),
	parse_snippet({ trig = "#letw", name = "let omega" }, "Let $\\Omega \\subset \\C$ be open."),
	parse_snippet({ trig = "#lim", name = "limit" }, "\\lim_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "#limsup", name = "limsup" }, "\\limsup_{${1:n} \\to ${2:\\infty}} "),
	parse_snippet({ trig = "#lll", name = "l" }, "\\ell"),
	parse_snippet({ trig = "#lr(", name = "left( right)" }, "\\left( ${1:${TM_SELECTED_TEXT}} \\right) $0"),
	parse_snippet({ trig = "#lr<", name = "left< right>" }, "\\left< ${1:${TM_SELECTED_TEXT}} \\right>$0"),
	parse_snippet({ trig = "#lr[", name = "left[ right]" }, "\\left[ ${1:${TM_SELECTED_TEXT}} \\right] $0"),
	parse_snippet({ trig = "#lr{", name = "left{ right}" }, "\\left\\{ ${1:${TM_SELECTED_TEXT}} \\right\\\\} $0"),
	parse_snippet({ trig = "#lr|", name = "left| right|" }, "\\left| ${1:${TM_SELECTED_TEXT}} \\right| $0"),
	parse_snippet({ trig = "#mcal", name = "mathcal" }, "\\mathcal{$1}$0"),
	parse_snippet({ trig = "#nabl", name = "nabla" }, "\\nabla "),
	parse_snippet({ trig = "#nnn", name = "bigcap" }, "\\bigcap_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "#norm", name = "norm" }, "\\|$1\\|$0"),
	parse_snippet({ trig = "#notin", name = "not in " }, "\\not\\in "),
	parse_snippet({ trig = "#ooo", name = "\\infty" }, "\\infty"),
	parse_snippet({ trig = "#part", name = "d/dx" }, "\\frac{\\partial ${1:V}}{\\partial ${2:x}} $0"),
	parse_snippet({ trig = "#pmat", name = "pmat" }, "\\begin{pmatrix} $1 \\end{pmatrix} $0"),
	parse_snippet({ trig = "#prod", name = "product" }, "\\prod_{${1:n=${2:1}}}^{${3:\\infty}} ${4:${TM_SELECTED_TEXT}} $0"),
	parse_snippet({ trig = "#rd", name = "to the ... power ^{()}" }, "^{($1)}$0 "),
	parse_snippet({ trig = "#rij", name = "mrij" }, "(${1:x}_${2:n})_{${3:$2}\\in${4:\\N}}$0"),
	parse_snippet({ trig = "#sequence", name = "Sequence indexed by n, from m to infinity" }, "(${1:a}_${2:n})_{${2:n}=${3:m}}^{${4:\\infty}}"),
	parse_snippet({ trig = "#sr", name = "Square ^2" }, "^2"),
	parse_snippet({ trig = "#stt", name = "text subscript" }, "_\\text{$1} $0"),
	parse_snippet({ trig = "#sum", name = "sum" }, "\\sum_{n=${1:1}}^{${2:\\infty}} ${3:a_n z^n}"),
	parse_snippet({ trig = "#taylor", name = "taylor" }, "\\sum_{${1:k}=${2:0}}^{${3:\\infty}} ${4:c_$1} (x-a)^$1 $0"),
	parse_snippet({ trig = "#td", name = "to the ... power ^{}" }, "^{$1}$0 "),
	parse_snippet({ trig = "#tt", name = "text" }, "\\text{$1}$0"),
	parse_snippet({ trig = "#uuu", name = "bigcup" }, "\\bigcup_{${1:i \\in ${2: I}}} $0"),
	parse_snippet({ trig = "#xii", name = "xi" }, "x_{i}"),
	parse_snippet({ trig = "#xjj", name = "xj" }, "x_{j}"),
	parse_snippet({ trig = "#xmm", name = "x" }, "x_{m}"),
	parse_snippet({ trig = "#xnn", name = "xn" }, "x_{n}"),
	parse_snippet({ trig = "#xp1", name = "x" }, "x_{n+1}"),
	parse_snippet({ trig = "#xx", name = "cross" }, "\\times "),
	parse_snippet({ trig = "#yii", name = "yi" }, "y_{i}"),
	parse_snippet({ trig = "#yjj", name = "yj" }, "y_{j}"),
	parse_snippet({ trig = "#ynn", name = "yn" }, "y_{n}"),
  parse_snippet({ trig = "#frac", name = "Fraction" }, "\\frac{$1}{$2}$0"),
	parse_snippet({ trig = "!=", name = "not equals" }, "\\neq "),
	parse_snippet({ trig = "!>", name = "mapsto" }, "\\mapsto "),
	parse_snippet({ trig = "**", name = "cdot", priority = 100 }, "\\cdot "),
	parse_snippet({ trig = "->", name = "to", priority = 100 }, "\\to "),
	parse_snippet({ trig = "...", name = "ldots", priority = 100 }, "\\ldots "),
	parse_snippet({ trig = ":=", name = "colon equals (lhs defined as rhs)" }, "\\coloneqq "),
	parse_snippet({ trig = "<!", name = "normal" }, "\\triangleleft "),
	parse_snippet({ trig = "<->", name = "leftrightarrow", priority = 200 }, "\\leftrightarrow"),
	parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),
	parse_snippet({ trig = "<<", name = "<<" }, "\\ll"),
	parse_snippet({ trig = "<=", name = "leq" }, "\\le "),
	parse_snippet({ trig = "<>", name = "hokje" }, "\\diamond "),
	parse_snippet({ trig = "=<", name = "implied by" }, "\\impliedby"),
	parse_snippet({ trig = "==", name = "equals" }, "&= $1 \\\\"),
	parse_snippet({ trig = "=>", name = "implies" }, "\\implies"),
	parse_snippet({ trig = ">=", name = "geq" }, "\\ge "),
	parse_snippet({ trig = ">>", name = ">>" }, "\\gg"),
	parse_snippet({ trig = "\\\\\\", name = "setminus" }, "\\setminus"),
	parse_snippet({ trig = "__", name = "subscript" }, "_{$1}$0"),
	parse_snippet({ trig = "inline_math", name = "inline math" }, "${1:equation}$"),
	parse_snippet({ trig = "math", name = "block math" }, "$$\n${1:equation}\n$$"),
	parse_snippet({ trig = "||", name = "mid" }, " \\mid "),
	parse_snippet({ trig = "~~", name = "~" }, "\\sim "),
}
-- stylua: ignore end

luasnip.add_snippets("markdown", markdown_snippets)
luasnip.add_snippets("markdown", equation_snippets)
