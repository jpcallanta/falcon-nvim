require("core.options")
require("core.keymaps")

vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- UI
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.catppuccin"),
	require("plugins.indent-blankline"),
	require("plugins.barbecue"),
	require("plugins.colorizer"),
	require("plugins.which-key"),
	-- LSP and completion
	require("plugins.treesitter"),
	require("plugins.lsp"),
	require("plugins.autocomplete"),
	require("plugins.conform"),
	require("plugins.actions-preview"),
	-- Editing
	require("plugins.autopairs"),
	-- Tools
	require("plugins.snacks"),
	require("plugins.noice"),
	require("plugins.render-markdown"),
	-- Git
	require("plugins.gitsigns"),
	-- Test and debug
	require("plugins.debug"),
})

-- Load Python type stubs helper only for Python buffers
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	once = true,
	callback = function()
		require("user.python-types").setup()
	end,
})
