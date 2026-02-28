local M = {}

function M.setup(event)
    local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('grr', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_references()
        else
            vim.lsp.buf.references()
        end
    end, '[G]oto [R]eferences')
    map('gri', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_implementations()
        else
            vim.lsp.buf.implementation()
        end
    end, '[G]oto [I]mplementation')
    map('grd', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_definitions()
        else
            vim.lsp.buf.definition()
        end
    end, '[G]oto [D]efinition')
    map('grD', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_declarations()
        else
            vim.lsp.buf.declaration()
        end
    end, '[G]oto [D]eclaration')
    map('gO', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_symbols()
        else
            vim.lsp.buf.document_symbol()
        end
    end, 'Open Document Symbols')
    map('gW', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_workspace_symbols()
        else
            vim.lsp.buf.workspace_symbol()
        end
    end, 'Open Workspace Symbols')
    map('grt', function()
        if Snacks and Snacks.picker then
            Snacks.picker.lsp_type_definitions()
        else
            vim.lsp.buf.type_definition()
        end
    end, '[G]oto [T]ype Definition')

    -- Signature help and hover
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
end

-- Setup global inlay hints toggle
function M.setup_global_inlay_hints()
    vim.keymap.set('n', '<leader>th', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients { bufnr = bufnr }

        for _, client in ipairs(clients) do
            if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })

                return
            end
        end

        vim.notify('No LSP client with inlay hint support found', vim.log.levels.WARN)
    end, { desc = 'LSP: [T]oggle Inlay [H]ints' })
end

return M 