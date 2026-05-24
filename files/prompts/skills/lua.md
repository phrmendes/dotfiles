---
name: lua
description: Conventions and rules for Lua development. Load this when working in any Lua codebase, including Neovim plugins, OpenResty, and standalone Lua scripts.
---

## Tooling

- Use `lua-language-server` for linting and type checking with `---@type`
  annotations.
- Use `stylua` for formatting.
- Use `busted` for testing in non-Neovim projects (OpenResty, standalone scripts,
  Lua libraries).
- Use `mini.test` for Neovim plugin tests. See `:help mini-test` for full docs.

## Resources

### Neovim documentation

Always verify Neovim API signatures, parameter order, and `@since` versions
against the official docs before writing or reviewing Neovim code. Never guess
— `vim.fs.read` is a documented example of a redirect that does not exist as a
real function.

- **Online** — `https://neovim.io/doc/user/` — use `webfetch` to read HTML pages:
  - `lua.html` — Lua guide and conventions
  - `api.html` — `vim.api` reference
  - `news.html` — changelog with deprecation notices and `@since` tags
  - `luaref-lua.html` — LuaJIT / Lua 5.1 reference

- **Local** — prefer this when the installed Neovim version may differ from the
  online docs (nightly builds, pinned nixpkgs, etc.):
  ```
  nvim --headless -c "help <topic>" -c "%print" -c "q" 2>/dev/null
  ```

## Code style

- Use `local` by default; never pollute the global namespace.
- Use `M = {}` + `return M` module pattern; avoid `module()` (deprecated).
- Use `---@param` and `---@return` annotations on all public functions.
- Keep modules focused; one primary responsibility per file.
- Prefer table constructors with named fields over positional for readability.
- Use `assert` for preconditions; use `pcall` / `v:errmsg` for graceful error
  handling in Neovim.

## LuaCATS type annotations

Always annotate with strong types. Prefer precise types over `any`.

### Primitives and basic types

```lua
---@type string
---@type number
---@type integer         -- lua-language-server integer subtype
---@type boolean
---@type nil
---@type any             -- last resort only; document why
```

### Tables and shapes

Define table shapes with `@class` and reuse them everywhere:

```lua
---@class Config
---@field width integer
---@field height integer
---@field title? string  -- optional field

---@type Config
local default = { width = 80, height = 24 }
```

### Functions

Annotate every parameter and return value on public functions:

```lua
---@param opts Config
---@param callback fun(err: string|nil, result: integer): boolean
---@return string|nil result
---@return string? err
local function process(opts, callback) end
```

Use `fun(...)` for inline function types:

```lua
---@type fun(name: string): integer
```

### Unions and optionals

```lua
---@type string|integer          -- union
---@type string?                 -- shorthand for string|nil
---@param value string|nil
```

### Arrays, dicts, and generics

```lua
---@type string[]                -- array of strings
---@type table<string, integer>  -- dict with string keys, integer values
---@type integer[][]             -- nested array

---@class Stack<T>
---@field _items T[]
---@field push fun(self: Stack, item: T)
---@field pop fun(self: Stack): T|nil
```

### Enums via `@alias`

```lua
---@alias LogLevel "debug"|"info"|"warn"|"error"

---@param level LogLevel
local function set_level(level) end
```

### Module typing

Type the module table so consumers get completion:

```lua
---@class MyModule
local M = {}

---@param name string
---@return string
function M.greet(name)
  return "Hello, " .. name
end

return M
```

### Rules

- Never leave a public function unannotated.
- Prefer `@class` over inline `table<...>` for shapes used in more than one place.
- Use `@alias` for any string enum — never bare string unions repeated across files.
- Mark optional fields with `?` on `@class`, not by union with `nil` inline.
- Use `@generic` / `@class<T>` for reusable container types.

## Neovim-specific conventions

### API surface

- Use `vim.api` for all operations — never `vim.cmd` string-splicing where an
  API equivalent exists.
- Use `vim.keymap.set` over `vim.api.nvim_set_keymap` over `vim.fn.maparg`.
- Use `vim.iter` everywhere — never raw `ipairs` / `pairs` / manual index loops.
- Use `vim.uv` over `vim.loop` (deprecated).
- `vim.cmd` only for commands with no `vim.api` equivalent.

### vim.iter

`vim.iter()` wraps a table or function into an `Iter` object with chainable
pipeline methods. The source type determines what is yielded per step:

- **List tables** (array-like) — yield the value only.
- **Dict tables** (non-list) — yield `key, value`.
- **Function iterators / `pairs()` / `ipairs()`** — yield all returned values.
- Returning `nil` from `map()` implicitly filters that element out.

**Core methods (all iterators)**

| Method           | Description                                             |
| ---------------- | ------------------------------------------------------- |
| `:map(f)`        | Transform each value; `nil` return filters the element  |
| `:filter(f)`     | Keep only elements where `f` returns truthy             |
| `:each(f)`       | Call `f` for side effects, drains the iterator          |
| `:fold(init, f)` | Reduce to a single accumulated value                    |
| `:find(f)`       | Return first value matching predicate or value          |
| `:any(pred)`     | True if any element matches                             |
| `:all(pred)`     | True if all elements match                              |
| `:next()`        | Consume and return the next value                       |
| `:peek()`        | Return next value without consuming it                  |
| `:nth(n)`        | Get the nth value (negative n counts from end on lists) |
| `:skip(n\|pred)` | Skip n items or while predicate is truthy               |
| `:take(n\|pred)` | Yield only first n items or while predicate is truthy   |
| `:enumerate()`   | Prepend a 1-based index to each value                   |
| `:totable()`     | Collect into a table (array-like result)                |
| `:join(delim)`   | Collect into a delimited string                         |
| `:last()`        | Drain and return the last value                         |
| `:unique(key?)`  | Remove duplicates; optional `key` fn computes hash      |

**List-only methods (`IterArray`)**

| Method                | Description                             |
| --------------------- | --------------------------------------- |
| `:rev()`              | Reverse the list                        |
| `:flatten(depth?)`    | Un-nest nested lists (default depth 1)  |
| `:slice(first, last)` | Set start/end bounds                    |
| `:pop()`              | Get and remove the last item            |
| `:rpeek()`            | Peek at the last item without consuming |
| `:rfind(f)`           | Find first match from the end           |
| `:rskip(n)`           | Discard n items from the end            |

**Key patterns**

```lua
-- map + filter: nil return from map acts as filter
vim.iter({ 1, 2, 3, 4 })
  :map(function(v) if v % 2 == 0 then return v * 3 end end)
  :totable()
-- { 6, 12 }

-- dict iteration yields key, value
vim.iter({ a = 1, b = 2, c = 3 })
  :filter(function(k, v) return v > 1 end)
  :totable()
-- { { 'b', 2 }, { 'c', 3 } }

-- fold to build a map-like table (totable() always produces an array)
vim.iter({ a = 1, b = 2, c = 3 })
  :filter(function(k, v) return v % 2 ~= 0 end)
  :fold({}, function(acc, k, v)
    acc[k] = v
    return acc
  end)
-- { a = 1, c = 3 }

-- function iterators (gsplit, gmatch, pairs…)
vim.iter(vim.gsplit('1,2,3', ','))
  :map(tonumber)
  :totable()
-- { 1, 2, 3 }
```

> **Note:** `vim.iter()` scans tables to decide list vs. dict. To avoid the
> scan cost on large tables, wrap with `ipairs()` — but that disables
> list-only methods (`:rev()`, `:flatten()`, etc.).

### Module structure

```
lua/plugin-name/
  init.lua        -- setup({}) entry point
  config.lua      -- default config + validation
  autocmds.lua    -- augroup definitions
  commands.lua    -- user commands
  health.lua      -- :checkhealth integration
```

## Testing

### TDD workflow

1. **RED** — write a failing test that captures the requirement.
2. **GREEN** — write the minimum code to make it pass.
3. **REFACTOR** — clean up, extract helpers, improve naming.
4. A test must fail for the right reason before any implementation begins.

### Neovim plugins (mini.test)

- Name test files `test_*.lua` inside a `tests/` directory.
- Organise hierarchically: top-level `T = MiniTest.new_set()`, nested groups
  with `MiniTest.new_set({ hooks = ... })`, test actions as callable fields.
- Use a child Neovim process for isolation — mini.test has no mocks or stubs;
  override what you need inside the child and reset via `child.restart()`.
- Expectations: `MiniTest.expect.equality()`, `MiniTest.expect.error()`,
  `MiniTest.expect.no_error()`, `MiniTest.expect.reference_screenshot()`.
- Use `MiniTest.skip()` to skip a case with an explanatory message.
- Use `MiniTest.finally()` to register cleanup that always runs.

```lua
local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
  hooks = {
    pre_case = function() child.start() end,
    post_case = function() child.stop() end,
  },
})

T['my feature'] = MiniTest.new_set()

T['my feature']['does the expected thing'] = function()
  child.lua([[require('my-plugin').setup({})]])
  local result = child.lua_get([[vim.g.my_plugin_state]])
  MiniTest.expect.equality(result, 'expected')
end

T['my feature']['raises on bad input'] = function()
  MiniTest.expect.error(function()
    child.lua([[require('my-plugin').setup({ invalid = true })]])
  end)
end

return T
```

### Non-Neovim Lua (busted)

```lua
describe("my_module", function()
  it("should return sum when given two numbers", function()
    local result = my_module.add(2, 3)
    assert.are.equal(5, result)
  end)

  it("should raise when given nil", function()
    assert.has_error(function() my_module.add(nil, 3) end)
  end)
end)
```

### Test naming

- Neovim: `T['feature group']['describes expected behaviour']`
- Busted: `it("should <behaviour> when <condition>")`
