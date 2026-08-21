-- =============================================================================
-- Indentation and tabs
-- =============================================================================
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.sts = 4
vim.opt.tabstop = 4

-- =============================================================================
-- Editing
-- =============================================================================
vim.opt.joinspaces = false

-- =============================================================================
-- Display and line numbers
-- =============================================================================
vim.opt.breakindent = true
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes:1"
vim.opt.sidescrolloff = 4
vim.opt.showbreak = "↳ "
vim.opt.textwidth = 80
vim.opt.wrap = false

-- =============================================================================
-- Search behavior
-- =============================================================================
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.smartcase = true

-- =============================================================================
-- Input and clipboard
-- =============================================================================
vim.opt.clipboard:append("unnamedplus")
vim.opt.mouse = "a"
vim.opt.virtualedit = "block"

-- =============================================================================
-- File and buffer behavior
-- =============================================================================
vim.opt.autoread = true
vim.opt.confirm = true
vim.opt.backup = false
vim.opt.fileencoding = "utf-8"
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.writebackup = false

-- =============================================================================
-- Completion
-- =============================================================================
vim.opt.completeopt = "menuone,noselect"
vim.opt.wildmode = "longest:full,full"
vim.opt.wildoptions = "pum"

-- =============================================================================
-- Key sequence timeout (leader key)
-- =============================================================================
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 250

-- =============================================================================
-- Window splits
-- =============================================================================
vim.opt.splitbelow = true
vim.opt.splitkeep = "topline"
vim.opt.splitright = true

-- =============================================================================
-- Appearance and colors
-- =============================================================================
vim.g.have_nerd_font = true
vim.opt.background = "dark"
vim.opt.belloff = "all"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.listchars = "tab:▸ ,trail:·,extends:→,precedes:←"
vim.opt.showmode = false
vim.opt.shortmess = "filnxtToOF"
vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NonText guibg=NONE ctermbg=NONE]])

-- =============================================================================
-- Autocommands
-- =============================================================================
-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Reload file when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "checktime",
})

-- GDScript: enforce spaces for indentation
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gdscript", "gd" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

-- Odin: enforce tabs for indentation (odin fmt canonical)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "odin",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

-- Go: enforce tabs for indentation (gofmt canonical)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

-- Python: enforce spaces for indentation (PEP 8)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

-- Shell: enforce spaces (Google Shell Style Guide - 2 spaces)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh", "bash" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- Ruby: enforce spaces (Ruby Style Guide - 2 spaces)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ruby",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- YAML: enforce spaces (2 spaces - tabs are invalid in YAML)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- Lua: enforce spaces (2 spaces - stylua / nvim convention)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- JavaScript: enforce spaces (2 spaces - Prettier / Airbnb default)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "javascript",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- JSON/JSONC: enforce spaces (2 spaces - Prettier / VS Code default)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- TOML: enforce spaces (2 spaces - taplo / common community style)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "toml",
	callback = function()
		vim.bo.expandtab = true
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

-- =============================================================================
-- Undo persistence
-- =============================================================================
vim.opt.undofile = true
local undodir = vim.fn.expand("~/.config/nvim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
