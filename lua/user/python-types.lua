local M = {}

-- Common type stub packages for popular libraries
local common_type_stubs = {
    'types-requests',
    'types-python-dateutil',
    'types-PyYAML',
    'types-redis',
    'types-setuptools',
    'types-six',
    'types-toml',
    'types-urllib3',
    'types-pillow',
    'types-aiofiles',
    'types-click',
    'types-markdown',
    'types-pkg-resources',
    'types-protobuf',
    'types-tabulate',
    'types-typed-ast',
}

-- Detect Python executable and package manager
function M.detect_python_env()
    local python_cmd = vim.fn.exepath('python3') ~= '' and 'python3' or vim.fn.exepath('python') ~= '' and 'python' or nil

    if not python_cmd then

        return nil, nil, 'Python executable not found'
    end

    -- Check if we're in a virtual environment
    local venv_python = os.getenv('VIRTUAL_ENV')

    if venv_python then
        python_cmd = venv_python .. '/bin/python'
    end

    -- Detect package manager (prefer venv pip if available)
    local pip_cmd = nil

    if venv_python and vim.fn.executable(venv_python .. '/bin/pip') == 1 then
        pip_cmd = venv_python .. '/bin/pip'
    elseif vim.fn.executable('pip') == 1 then
        pip_cmd = 'pip'
    elseif vim.fn.executable('pip3') == 1 then
        pip_cmd = 'pip3'
    else

        return python_cmd, nil, 'pip not found'
    end

    return python_cmd, pip_cmd, nil
end

-- Install type stubs for a specific package
function M.install_type_stub(package_name, callback)
    local python_cmd, pip_cmd, error_msg = M.detect_python_env()

    if error_msg then
        vim.notify('Error: ' .. error_msg, vim.log.levels.ERROR)
        return
    end

    local stub_package = 'types-' .. package_name:lower()
    local install_cmd = { pip_cmd, 'install', stub_package }

    vim.notify('Installing ' .. stub_package .. '...', vim.log.levels.INFO)

    vim.fn.jobstart(install_cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_exit = function(_, code)
            if code == 0 then
                vim.notify('Successfully installed ' .. stub_package, vim.log.levels.INFO)
                if callback then
                    callback()
                end
            else
                vim.notify('Failed to install ' .. stub_package, vim.log.levels.ERROR)
            end
        end,
    })
end

-- Install common type stubs
function M.install_common_stubs()
    local python_cmd, pip_cmd, error_msg = M.detect_python_env()

    if error_msg then
        vim.notify('Error: ' .. error_msg, vim.log.levels.ERROR)
        return
    end

    local install_cmd = { pip_cmd, 'install' }
    vim.list_extend(install_cmd, common_type_stubs)

    vim.notify('Installing common type stubs...', vim.log.levels.INFO)

    vim.fn.jobstart(install_cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_exit = function(_, code)
            if code == 0 then
                vim.notify('Successfully installed common type stubs', vim.log.levels.INFO)
                vim.notify('Restart LSP or reload buffer to see changes', vim.log.levels.INFO)
            else
                vim.notify('Some type stubs failed to install', vim.log.levels.WARN)
            end
        end,
    })
end

-- Show available type stubs
function M.show_available_stubs()
    local stubs_list = 'Available type stub packages:\n\n'
    for _, stub in ipairs(common_type_stubs) do
        stubs_list = stubs_list .. '  • ' .. stub .. '\n'
    end
    stubs_list = stubs_list .. '\nTo install: :PythonTypesInstall <package-name>\n'
    stubs_list = stubs_list .. 'To install common ones: :PythonTypesInstallCommon'

    vim.notify(stubs_list, vim.log.levels.INFO, { title = 'Python Type Stubs' })
end

-- Setup user commands
function M.setup()
    vim.api.nvim_create_user_command('PythonTypesInstall', function(opts)
        if not opts.args or opts.args == '' then
            vim.notify('Usage: :PythonTypesInstall <package-name>', vim.log.levels.ERROR)
            return
        end

        M.install_type_stub(opts.args, function()
            -- Restart pyright if it's attached
            local clients = vim.lsp.get_active_clients { name = 'pyright' }
            for _, client in ipairs(clients) do
                vim.notify('Restarting Pyright...', vim.log.levels.INFO)
                vim.cmd('LspRestart pyright')
            end
        end)
    end, { nargs = 1, desc = 'Install type stubs for a Python package' })

    vim.api.nvim_create_user_command('PythonTypesInstallCommon', function()
        M.install_common_stubs()
    end, { desc = 'Install common Python type stub packages' })

    vim.api.nvim_create_user_command('PythonTypesList', function()
        M.show_available_stubs()
    end, { desc = 'Show available Python type stub packages' })
end

return M
