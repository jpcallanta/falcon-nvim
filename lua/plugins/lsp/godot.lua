local M = {}

-- Setup external Godot LSP server when configured.
function M.setup(capabilities, servers)
    local godot_config = servers.godot_lsp
    if not godot_config then

        return
    end

    local has_socat = vim.fn.executable('socat') == 1
    local has_nc = vim.fn.executable('nc') == 1
    if not has_socat and not has_nc then
        vim.notify('Godot LSP requires socat or nc to connect via TCP. Install with: sudo apt install socat', vim.log.levels.WARN)

        return
    end

    godot_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, godot_config.capabilities or {})

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

    godot_config.cmd = actual_cmd

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
