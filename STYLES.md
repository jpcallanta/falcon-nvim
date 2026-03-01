# STYLES.md

This file is the style guide for humans and coding agents editing this Neovim config. Follow it for consistency when adding or changing code.

## Lua formatting

- Indent with 4 spaces; no tabs in source (see `lua/core/options.lua`).
- Aim for 80–100 character line length where readable; break long lines sensibly.
- Put a newline before and after groups of assignment statements.
- Put a newline before and after groups of variable declarations.
- Put a newline before and after top-level `if` blocks.

## Comments

- **Sections**: In config/options files use a full-width separator and title:
  ```lua
  -- =============================================================================
  -- Section title
  -- =============================================================================
  ```
  See `lua/core/options.lua`. In keymaps or smaller files, short section comments are fine (e.g. `-- General`, `-- Buffers`); see `lua/core/keymaps.lua`.
- **Functions**: Add a comment immediately before every function stating its purpose in one line; keep it concise.
- **Top-level conditionals**: Add a comment before each top-level `if` stating what the condition checks. Sub-`if` blocks need not be commented.
- Keep comments concise; avoid repetition and filler.

## Modules and structure

- Use `local M = {}` and `return M` for Lua modules. Expose public API as `function M.name()`; use `local function` for internal helpers. See `lua/user/python-types.lua` and `lua/plugins/lsp/servers.lua`.
- Prefer small, single-purpose functions that are easy to unit test; break this rule only when necessary for correctness.

## Returns and control flow

- Insert a blank line before `return` in functions.

## Neovim-specific

- **Options**: Prefer `vim.opt` (and `vim.bo` / `vim.wo` for buffer/window scope). Use `vim.o` only when reading a scalar value for comparison (e.g. in expressions) if `vim.opt` would return an option object.
- **Require**: Either `require 'module.path'` or `require('module.path')`; use parentheses when chaining, e.g. `require('lazy').setup(...)`. See `init.lua`.
- **Strings**: Single quotes by default; double quotes for `vim.cmd` or when the string contains single quotes.

## Plugins (Lazy.nvim specs)

- Plugin spec is a table returned at top level: `return { ... }`.
- Use `opts = { ... }` for static config; use `config = function() ... end` when logic or side effects are needed.
- Keep plugin tables readable; use short inline comments for non-obvious choices. See `lua/plugins/conform.lua` and `lua/plugins/autocomplete.lua`.

## Misc

- Run the linter after changes (e.g. stylua, luacheck, or editor lint).
- Do not run tests in interactive mode for TUI apps; advise manual testing and paste or screenshot output if needed.
- Code or Markdown should not exceed 80 character width. Either rephrase or use multiline as needed.
