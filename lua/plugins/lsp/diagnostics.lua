local M = {}

-- Helper function to check if a diagnostic is a Pyright false positive
local function is_pyright_false_positive(message)
    if not message then

        return false
    end

    local msg = message:lower()

    return (msg:match('cannot access') and msg:match('unknown'))
        or msg:match('cannot access attribute')
        or msg:match('attribute.*is unknown')
        or msg:match('attribute.*for class')
        or (msg:match('for class') and msg:match('unknown'))
        or msg:match('attribute.*unknown')
end

-- Helper function to check if client is Pyright/Pylance
local function is_pyright_client(client_name, source)
    local name = (client_name or ''):lower()
    local src = (source or ''):lower()

    return name == 'pyright' or name == 'pylance' or src == 'pyright' or src == 'pylance'
end

function M.setup()
    vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
            text = {
                [vim.diagnostic.severity.ERROR] = '󰅚 ',
                [vim.diagnostic.severity.WARN] = '󰀪 ',
                [vim.diagnostic.severity.INFO] = '󰋽 ',
                [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
        } or {},
        virtual_text = {
            source = 'if_many',
            spacing = 2,
            format = function(diagnostic)
                return diagnostic.message
            end,
        },
        filter = function(diagnostic)
            if type(diagnostic) ~= 'table' or not diagnostic.message then

                return true
            end

            local source = diagnostic.source or ''

            if is_pyright_client(nil, source) and is_pyright_false_positive(diagnostic.message) then

                return false
            end

            return true
        end,
    }

    -- Override Pyright diagnostics handler to filter false positives
    local default_handler = vim.lsp.handlers['textDocument/publishDiagnostics']

    vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        if err or not result or not result.diagnostics or #result.diagnostics == 0 then
            if default_handler then
                return default_handler(err, result, ctx, config)
            else
                return vim.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end
        end

        local is_pyright = false

        if ctx and ctx.client_id then
            local ok, client = pcall(vim.lsp.get_client_by_id, ctx.client_id)
            if ok and client then
                is_pyright = is_pyright_client(client.name, nil)
            end
        end

        if not is_pyright and result.diagnostics[1] then
            is_pyright = is_pyright_client(nil, result.diagnostics[1].source)
        end

        if is_pyright then
            result.diagnostics = vim.tbl_filter(function(diagnostic)
                return not is_pyright_false_positive(diagnostic.message)
            end, result.diagnostics)
        end

        if default_handler then
            return default_handler(err, result, ctx, config)
        else
            return vim.diagnostic.on_publish_diagnostics(err, result, ctx, config)
        end
    end
end

return M 