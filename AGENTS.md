# AGENTS.md

Style guide for this Neovim config.

## Lua

- 4 spaces indent; no tabs.
- 80–100 char line length; break long lines sensibly.
- Newline before/after assignment groups, variable declarations, and top-level `if` blocks.
- Single quotes by default; double quotes in `vim.cmd` or when string contains single quotes.

## Comments

- **Sections**: Full-width separator in config/options files (`-- ===...`); short comments (`-- General`) in keymaps/small files.
- **Functions**: One-line comment before every function stating purpose.
- **Top-level `if`**: Comment before each stating the condition. Sub-`if`s unneeded.

## Modules

- `local M = {}` / `return M`. Public API: `function M.name()`. Internal: `local function`.
- Small, single-purpose functions.

## Control flow

- Blank line before `return` in functions.

## Neovim

- Prefer `vim.opt` / `vim.bo` / `vim.wo`. Use `vim.o` only for scalar comparisons.
- `require 'mod'` or `require('mod')`; use parens when chaining.
- `opts = {}` for static plugin config; `config = function() end` when logic needed.

## Plugins (Lazy.nvim)

- Spec: `return { ... }` table. Inline comments for non-obvious choices.

## Misc

- Run linter after changes.
- No tests for TUI apps; advise manual testing.
- Max 80 char width.
