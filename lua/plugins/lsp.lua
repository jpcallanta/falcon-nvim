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
        -- Override hover handler globally to suppress "No information available" notifications
        local original_hover_handler = vim.lsp.handlers['textDocument/hover']
        vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
            if err then
                return original_hover_handler and original_hover_handler(err, result, ctx, config)
            end

            -- Suppress empty or "No information available" results
            if not result or not result.contents then
                return
            end

            local contents = result.contents
            local text = ''

            if type(contents) == 'string' then
                text = contents
            elseif type(contents) == 'table' then
                if contents.value then
                    text = contents.value
                elseif #contents > 0 then
                    text = contents[1].value or contents[1] or ''
                end
            end

            -- Suppress "No information available" messages
            if text:lower():match('no information available') then
                return
            end

            -- Call original handler for valid results
            if original_hover_handler then
                return original_hover_handler(err, result, ctx, config)
            else
                return vim.lsp.util.open_floating_preview(result.contents, 'markdown', config)
            end
        end

        -- Override signature help handler to suppress "no signature help available" notifications
        local original_signature_handler = vim.lsp.handlers['textDocument/signatureHelp']
        vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
            if err then
                return original_signature_handler and original_signature_handler(err, result, ctx, config)
            end

            -- Suppress empty results
            if not result or not result.signatures or #result.signatures == 0 then
                return
            end

            -- Call original handler for valid results
            if original_signature_handler then
                return original_signature_handler(err, result, ctx, config)
            else
                return vim.lsp.signature_help()
            end
        end

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

        -- Setup Godot LSP server (external, not managed by Mason)
        local servers = require('plugins.lsp.servers').servers
        local godot_config = servers.godot_lsp
        if godot_config then
            -- Check if required tools are available before setting up
            local has_socat = vim.fn.executable('socat') == 1
            local has_nc = vim.fn.executable('nc') == 1

            if not has_socat and not has_nc then
                vim.notify('Godot LSP requires socat or nc to connect via TCP. Install with: sudo apt install socat', vim.log.levels.WARN)
            else
                godot_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, godot_config.capabilities or {})

                -- Evaluate cmd function upfront to get the actual command
                local cmd_func = godot_config.cmd
                local actual_cmd = nil
                if type(cmd_func) == 'function' then
                    actual_cmd = cmd_func()
                else
                    actual_cmd = cmd_func
                end

                if not actual_cmd or #actual_cmd == 0 then
                    vim.notify('Godot LSP: Invalid command configuration', vim.log.levels.ERROR)
                    return
                end

                -- Register and setup custom Godot LSP server
                local lspconfig = require('lspconfig')
                local configs = require('lspconfig.configs')
                if not configs.godot_lsp then
                    configs.godot_lsp = {
                        default_config = {
                            name = 'godot_lsp',
                            cmd = actual_cmd,
                            root_dir = godot_config.root_dir,
                            filetypes = godot_config.filetypes,
                            single_file_support = godot_config.single_file_support,
                        },
                    }
                end

                -- Use the evaluated command
                godot_config.cmd = actual_cmd

                -- Add handlers for better error reporting
                local original_on_init = godot_config.on_init
                godot_config.on_init = function(client, initialize_result)
                    if original_on_init then
                        original_on_init(client, initialize_result)
                    end
                end

                local original_on_attach = godot_config.on_attach
                godot_config.on_attach = function(client, bufnr)
                    if original_on_attach then
                        original_on_attach(client, bufnr)
                    end
                end

                -- Wrap setup in pcall to catch initialization errors
                local ok, err = pcall(function()
                    lspconfig.godot_lsp.setup(godot_config)
                end)

                if not ok then
                    vim.notify('Failed to setup Godot LSP: ' .. tostring(err), vim.log.levels.ERROR)
                end
            end
        end
    end,
}
