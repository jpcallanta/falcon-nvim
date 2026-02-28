local M = {}

-- Detect Python interpreter from pyenv or system
local function detect_python_path()
    -- Check for virtual environment first
    local venv = os.getenv('VIRTUAL_ENV')
    if venv then
        local venv_python = venv .. '/bin/python'
        if vim.fn.executable(venv_python) == 1 then
            return venv_python
        end
    end

    -- Check for pyenv via environment variables
    local pyenv_root = os.getenv('PYENV_ROOT') or vim.fn.expand('~/.pyenv')
    local pyenv_version = os.getenv('PYENV_VERSION')

    if pyenv_version then
        local pyenv_python = pyenv_root .. '/versions/' .. pyenv_version .. '/bin/python'
        if vim.fn.executable(pyenv_python) == 1 then
            return pyenv_python
        end
    end

    -- Try to get pyenv version from .python-version file
    local python_version_file = vim.fn.findfile('.python-version', '.;')
    if python_version_file ~= '' then
        local ok, version_lines = pcall(vim.fn.readfile, python_version_file)
        if ok and version_lines and #version_lines > 0 then
            local version = vim.fn.trim(version_lines[1])
            if version and version ~= '' then
                local pyenv_python = pyenv_root .. '/versions/' .. version .. '/bin/python'
                if vim.fn.executable(pyenv_python) == 1 then
                    return pyenv_python
                end
            end
        end
    end

    -- Fallback to system python
    local python3 = vim.fn.exepath('python3')
    if python3 ~= '' then
        return python3
    end

    local python = vim.fn.exepath('python')
    if python ~= '' then
        return python
    end

    return nil
end

M.servers = {
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                diagnostics = {
                    globals = {
                        'vim',
                        'require',
                        'pcall',
                        'pairs',
                        'ipairs',
                        'next',
                        'type',
                        'tonumber',
                        'tostring',
                        'unpack',
                        'string',
                        'table',
                        'math',
                        'coroutine',
                        'io',
                        'os',
                        'debug',
                    },
                },
                workspace = {
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.stdpath('config') .. '/lua'] = true,
                    },
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    ruff = {
        init_options = {
            settings = {
                args = {},
            },
        },
    },
    pyright = {
        settings = {
            python = {
                pythonPath = detect_python_path(),
                analysis = {
                    typeCheckingMode = 'off',
                    autoImportCompletions = true,
                    autoSearchPaths = true,
                    diagnosticMode = 'workspace',
                    useLibraryCodeForTypes = true,
                    -- Pyright automatically discovers type stubs from Python environment
                    -- No need to hardcode stubPath - it will find stubs in site-packages
                    diagnosticSeverityOverrides = {
                        reportMissingImports = 'warning',
                        reportMissingTypeStubs = 'information',
                        reportUnusedImport = 'warning',
                        reportUnusedClass = 'information',
                        reportUnusedFunction = 'information',
                        reportUnusedVariable = 'information',
                        reportDuplicateImport = 'warning',
                        reportWildcardImportFromLibrary = 'warning',
                        reportOptionalSubscript = 'warning',
                        reportOptionalMemberAccess = 'none',
                        reportOptionalCall = 'warning',
                        reportOptionalIterable = 'warning',
                        reportOptionalContextManager = 'warning',
                        reportOptionalOperand = 'warning',
                        reportGeneralTypeIssues = 'none',
                        reportPrivateImportUsage = 'information',
                        reportConstantRedefinition = 'warning',
                        reportIncompatibleMethodOverride = 'warning',
                        reportIncompatibleVariableOverride = 'warning',
                        reportOverlappingOverloads = 'error',
                        reportMissingSuperCall = 'warning',
                        reportUninitializedInstanceVariable = 'none',
                        reportInvalidStringEscapeSequence = 'error',
                        reportUnknownParameterType = 'none',
                        reportUnknownArgumentType = 'none',
                        reportUnknownLambdaType = 'none',
                        reportUnknownVariableType = 'none',
                        reportUnknownMemberType = 'none',
                        reportMissingParameterType = 'none',
                        reportMissingTypeArgument = 'none',
                        reportInvalidTypeVarUse = 'error',
                        reportCallInDefaultInitializer = 'warning',
                        reportUnnecessaryIsInstance = 'warning',
                        reportUnnecessaryCast = 'warning',
                        reportUnnecessaryComparison = 'warning',
                        reportAssertAlwaysTrue = 'warning',
                        reportSelfClsParameterName = 'information',
                        reportImplicitStringConcatenation = 'none',
                        reportUnusedCallResult = 'information',
                        reportUnusedExpression = 'warning',
                        reportUnnecessaryTypeIgnoreComment = 'warning',
                        reportMatchNotExhaustive = 'warning',
                        reportShadowedImports = 'warning',
                    },
                },
            },
        },
    },
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    unreachable = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                    unusedvariable = true,
                    staticcheck = true,
                },
                codelenses = {
                    gc_details = true,
                    generate = true,
                    regenerate_cgo = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                staticcheck = true,
                usePlaceholders = true,
            },
        },
    },
    bashls = {},
    godot_lsp = {
        cmd = function()
            -- Check for socat first (preferred for bidirectional TCP)
            if vim.fn.executable('socat') == 1 then
                return { 'socat', 'STDIO', 'TCP:localhost:6008' }
            end

            -- Fallback to nc (netcat) if socat is not available
            -- Note: nc may not work well for bidirectional LSP communication
            if vim.fn.executable('nc') == 1 then
                -- Use nc with -N flag for better behavior (close on EOF)
                return { 'nc', '-N', 'localhost', '6008' }
            end

            -- Return a dummy command that will fail gracefully
            -- This prevents nil errors but will show a connection error
            return { 'sh', '-c', 'echo "socat or nc required for Godot LSP" && exit 1' }
        end,
        root_dir = function(fname)
            -- Use current working directory or file directory as root
            return vim.fn.getcwd()
        end,
        filetypes = { 'gdscript', 'gd' },
        single_file_support = true,
        -- Add initialization options if needed
        init_options = {},
    },
}

-- Don't auto-install LSP servers - install manually via :Mason when needed
M.ensure_installed = {
    'stylua', -- Lua formatter
}

return M
