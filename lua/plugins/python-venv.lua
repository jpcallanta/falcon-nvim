return {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
        'mfussenegger/nvim-dap-python',
    },
    keys = {
        {
            '<leader>cv',
            '<cmd>VenvSelect<cr>',
            desc = 'Select Python [V]env',
        },
    },
    opts = {
        name = { 'venv', '.venv', 'env', '.env' },
        auto_refresh = false,
        settings = {
            python = {
                {
                    path = vim.fn.expand('~/.virtualenvs'),
                    name = 'Virtualenvs',
                },
                {
                    path = vim.fn.expand('~/.pyenv/versions'),
                    name = 'Pyenv',
                },
                {
                    path = vim.fn.expand('~/.conda/envs'),
                    name = 'Conda',
                },
            },
        },
        search = {
            my_venvs = vim.fn.expand('~/.virtualenvs'),
            parents = 2,
        },
        dap_enabled = true,
        notify_user_on_activate = false,
    },
    init = function()
        vim.g.venv_selector_auto_refresh = false
    end,
}
