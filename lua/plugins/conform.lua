return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_fallback = true }
            end,
            mode = 'n',
            desc = '[F]ormat buffer',
        },
    },
    init = function()
        vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            end

            return {
                timeout_ms = 500,
                lsp_fallback = true,
            }
        end,
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'ruff_format' },
            go = { 'goimports', 'golines' },
            gdscript = { 'gdformat' },
            gd = { 'gdformat' },
            -- codespell removed from wildcard - too aggressive for all filetypes
            -- Add specific filetypes if needed: markdown = { 'codespell' },
        },
        formatters = {
            ruff_format = {
                condition = function(ctx)
                    return vim.fn.executable('ruff') == 1
                end,
                args = { 'format', '--stdin-filename', '$FILENAME', '-' },
            },
            goimports = {
                condition = function(ctx)
                    return vim.fn.executable('goimports') == 1
                end,
            },
            golines = {
                condition = function(ctx)
                    return vim.fn.executable('golines') == 1
                end,
                args = { '--max-len=120', '--base-formatter=gofumpt' },
            },
            gdformat = {
                condition = function(ctx)
                    return vim.fn.executable('gdformat') == 1
                end,
            },
        },
    },
}
