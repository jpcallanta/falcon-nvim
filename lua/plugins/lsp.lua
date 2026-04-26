return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'saghen/blink.cmp',
    },
    config = function()
        require('plugins.lsp.handlers').setup()

        -- Setup global inlay hints toggle
        require('plugins.lsp.keymaps').setup_global_inlay_hints()

        local lsp_attach_group = vim.api.nvim_create_augroup('falcon-lsp-attach', { clear = true })
        local highlight_augroup = vim.api.nvim_create_augroup('falcon-lsp-highlight', { clear = false })

        -- Clear document highlight autocmds when LSP detaches from a buffer
        vim.api.nvim_create_autocmd('LspDetach', {
            group = lsp_attach_group,
            callback = function(event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event.buf }
            end,
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = lsp_attach_group,
            callback = function(event)
                require('plugins.lsp.keymaps').setup(event)

                local bufnr = event.buf
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = bufnr,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        -- Setup diagnostics
        require('plugins.lsp.diagnostics').setup()

        -- Setup Mason and LSP servers
        local capabilities = require('blink.cmp').get_lsp_capabilities()
        require('plugins.lsp.mason').setup(capabilities)

        local servers = require('plugins.lsp.servers').servers
        require('plugins.lsp.godot').setup(capabilities, servers)
    end,
}
