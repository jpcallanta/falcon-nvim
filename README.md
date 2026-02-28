# falcon-nvim

A modern Neovim config in Lua using the Lazy.nvim plugin manager.

## Features

- **Beautiful UI**: Catppuccin Macchiato theme with transparent background
- **Fuzzy Finder**: Fzf-lua for file/search; Snacks for pickers and Git
- **Fast Completion**: Blink.cmp with LSP integration and LuaSnip snippets
- **Code Formatting**: Conform.nvim with format-on-save and LSP fallback
- **Code Actions**: Actions-preview for LSP code actions with preview
- **Testing**: Neotest for running and debugging tests (Go and Python support)
- **Debugging**: DAP support with UI, configured for Go and Python development
- **Git Integration**: Gitsigns for status indicators; Snacks for Git operations
- **Python Support**: Virtual environment selector and type stubs helper
- **Syntax Highlighting**: Tree-sitter for enhanced syntax highlighting
- **Status Line**: Lualine status line; Barbecue for context navigation
- **Keymaps**: Which-key for keybindings (conflicts resolved, leader timeout)
- **LSP**: Mason-managed language servers with automatic installation
- **Terminal**: Terminal support via split windows

## Quick Start

### Prerequisites

- Neovim 0.9.0 or higher
- Git
- A Nerd Font (recommended for icons)

### Installation

1. **Backup your existing Neovim config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://codeberg.org/pwnderpants/falcon-nvim ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

   The first time you run Neovim, it will automatically install all plugins.

## Installed Plugins

### Core Plugins
- **[Lazy.nvim](https://github.com/folke/lazy.nvim)** - Fast plugin manager
- **[Catppuccin](https://github.com/catppuccin/nvim)** - Soothing color scheme
- **[Fzf-lua](https://github.com/ibhagwan/fzf-lua)** -
  Fuzzy finder (files, search)
- **[Snacks.nvim](https://github.com/folke/snacks.nvim)** - Pickers & utilities
- **[Tree-sitter](https://github.com/nvim-treesitter/nvim-treesitter)** -
  Syntax highlighting
- **[LSP Config](https://github.com/neovim/nvim-lspconfig)** - LSP client config

### UI & Experience
- **[Lualine](https://github.com/nvim-lualine/lualine.nvim)** - Status line
- **[Bufferline](https://github.com/akinsho/bufferline.nvim)** - Tab line
- **[Indent Blankline](https://github.com/lukas-reineke/indent-blankline.nvim)**
  - Indent guides
- **[Colorizer](https://github.com/catgoose/nvim-colorizer.lua)** -
  Color highlighting
- **[Noice](https://github.com/folke/noice.nvim)** - UI improvements
- **[Which Key](https://github.com/folke/which-key.nvim)** - Keymap discovery

### Development Tools
- **[Blink.cmp](https://github.com/saghen/blink.cmp)** - Fast completion engine
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** -
  Snippets (friendly-snippets)
- **[Conform.nvim](https://github.com/stevearc/conform.nvim)** -
  Formatter, format-on-save
- **[Actions-preview](https://github.com/aznhe21/actions-preview.nvim)** -
  LSP code actions (preview)
- **[Neotest](https://github.com/nvim-neotest/neotest)** - Tests (Go, Python)
- **[Mason](https://github.com/mason-org/mason.nvim)** -
  LSP/DAP package manager, auto install
- **[DAP](https://github.com/mfussenegger/nvim-dap)** - Debug adapter (DAP) + UI
- **[DAP-UI](https://github.com/rcarriga/nvim-dap-ui)** - Debug UI interface
- **[DAP-Go](https://github.com/leoluz/nvim-dap-go)** - Go debugging support
- **[DAP-Python](https://github.com/mfussenegger/nvim-dap-python)** - Python DAP
- **[Venv-selector](https://github.com/linux-cultist/venv-selector.nvim)** -
  Python venv selector

### Git Integration
- **[Gitsigns](https://github.com/lewis6991/gitsigns.nvim)** - Git gutter status
- **[Barbecue](https://github.com/utilyre/barbecue.nvim)** - Context navigation

### Productivity & Utilities
- **[Render MD](https://github.com/MeanderingProgrammer/render-markdown.nvim)**
  Markdown preview

## Key Mappings

Leader is `<Space>`. Press `<Space>?` (Which-key) to see keybindings.
Keymaps are defined in `lua/core/keymaps.lua`.

| Area        | Examples |
|------------|----------|
| General    | `<C-s>` save, `<C-q>` quit |
| Files      | `<leader>f` format, `<leader>ff` find files (Fzf-lua/Snacks) |
| Buffers    | `<Tab>` / `<S-Tab>` next/prev buffer, `<leader>,` buffer picker |
| LSP        | `gd` go to definition, `gr` references, `gra` code actions |
| Git        | `<leader>gs` status, `<leader>gg` Lazygit |
| Testing    | `<leader>tt` run nearest test, `<leader>td` debug test |
| Debug      | `<F5>` start/continue, `<F7>` toggle UI |
| Terminal   | `<leader>tv` open terminal in split |
| Python     | `<leader>cv` select venv |

## Theme

**Catppuccin Macchiato**: transparent bg, italic comments, plugin integration.
Configure in `lua/plugins/catppuccin.lua`.

## Configuration Structure

```
~/.config/nvim/
├── init.lua              # Main entry point, loads Lazy.nvim
├── lua/
│   ├── core/
│   │   ├── options.lua   # Neovim options and settings
│   │   └── keymaps.lua   # Core key mappings
│   ├── plugins/          # Plugin configurations
│   │   ├── lsp/          # LSP configurations
│   │   │   ├── diagnostics.lua
│   │   │   ├── keymaps.lua
│   │   │   ├── mason.lua
│   │   │   └── servers.lua
│   │   ├── actions-preview.lua
│   │   ├── autocomplete.lua
│   │   ├── autopairs.lua
│   │   ├── barbecue.lua
│   │   ├── bufferline.lua
│   │   ├── catppuccin.lua
│   │   ├── colorizer.lua
│   │   ├── conform.lua
│   │   ├── debug.lua
│   │   ├── fzf-lua.lua
│   │   ├── gitsigns.lua
│   │   ├── indent-blankline.lua
│   │   ├── lsp.lua
│   │   ├── lualine.lua
│   │   ├── neotest.lua
│   │   ├── noice.lua
│   │   ├── python-venv.lua
│   │   ├── render-markdown.lua
│   │   ├── snacks.lua
│   │   ├── treesitter.lua
│   │   └── which-key.lua
│   └── user/             # User customizations
│       └── python-types.lua # Python type stubs helper
└── lazy-lock.json        # Plugin lock file (auto-generated)
```

## Getting Started Tips

- Install a **Nerd Font** (e.g. JetBrains Mono, Fira Code) for icons.
- **Mason** installs LSPs and debuggers (e.g. Delve for Go) when you open files.
- **Format on save** is enabled (Conform.nvim with LSP fallback).
- Customize in `lua/user/`; use `<Space>?` (Which-key) to browse keybindings.
- Python: `<leader>cv` select venv; `:PythonTypesInstallCommon` for type stubs.
- Testing: `<leader>tt` run test, `<leader>td` debug.

## Customization

### Adding Custom Plugins
Create a new file in `lua/plugins/` and add it to the plugin list in `init.lua`.

### Modifying Keymaps
Edit `lua/core/keymaps.lua` to customize keybindings.

### Changing Theme
Modify `lua/plugins/catppuccin.lua` to change theme settings.

## Requirements

- **Neovim**: 0.9.0+ (with Lua support)
- **Git**: For plugin installation
- **Nerd Font**: For proper icon display (recommended)
- **Go**: For Go development support (optional)
- **Python**: For Python development support (optional)
- **Ruff**: For Python formatting (optional, installs via Mason or system)
- **Stylu**: For Lua formatting (optional, installs via Mason)

## Contributing

Feel free to submit issues and enhancement requests!

## License

MIT License. See the LICENSE file for details.

---

**Happy coding with falcon-nvim!**
