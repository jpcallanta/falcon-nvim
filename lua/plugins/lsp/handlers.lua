local M = {}

-- Setup hover and signature handlers with noise suppression.
function M.setup()
    local original_hover_handler = vim.lsp.handlers['textDocument/hover']
    vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
        if err then

            return original_hover_handler and original_hover_handler(err, result, ctx, config)
        end

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

        if text:lower():match('no information available') then

            return
        end

        if original_hover_handler then

            return original_hover_handler(err, result, ctx, config)
        end

        return vim.lsp.util.open_floating_preview(result.contents, 'markdown', config)
    end

    local original_signature_handler = vim.lsp.handlers['textDocument/signatureHelp']
    vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
        if err then

            return original_signature_handler and original_signature_handler(err, result, ctx, config)
        end

        if not result or not result.signatures or #result.signatures == 0 then

            return
        end

        if original_signature_handler then

            return original_signature_handler(err, result, ctx, config)
        end

        return vim.lsp.signature_help()
    end
end

return M
