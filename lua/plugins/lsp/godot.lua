local M = {}

-- Setup external Godot LSP server when configured.
function M.setup(capabilities, servers)
    local godot_config = servers.godot_lsp
    if not godot_config then

        return
    end

    -- Transport is provided by vim.lsp.rpc.connect (see servers.lua), so no
    -- external socat/nc bridge is needed before registering the server.

    godot_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, godot_config.capabilities or {})

    -- nvim accepts `cmd` as either an argv list (table) or an RPC client factory
    -- (function, e.g. the result of vim.lsp.rpc.connect). Validate both forms
    -- without indexing a function with `#`.
    local actual_cmd = godot_config.cmd
    local cmd_valid = actual_cmd ~= nil
        and (type(actual_cmd) == 'function' or (type(actual_cmd) == 'table' and #actual_cmd > 0))
    if not cmd_valid then
        vim.notify('Godot LSP: Invalid command configuration', vim.log.levels.ERROR)

        return
    end

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

    local ok, err = pcall(function()
        lspconfig.godot_lsp.setup(godot_config)
    end)

    if not ok then
        vim.notify('Failed to setup Godot LSP: ' .. tostring(err), vim.log.levels.ERROR)
    end
end

return M
