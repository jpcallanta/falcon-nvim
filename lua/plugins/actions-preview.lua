return {
    'aznhe21/actions-preview.nvim',
    keys = {
        {
            'gra',
            function()
                require('actions-preview').code_actions()
            end,
            mode = { 'n', 'v' },
            desc = 'LSP: Code [A]ctions (preview)',
        },
    },
    config = function()
        require('actions-preview').setup {}
    end,
}
