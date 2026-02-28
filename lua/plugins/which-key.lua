return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
        local wk = require('which-key')

        wk.setup({
            win = {
                border = 'rounded',
                row = math.huge,
                col = 0,
                padding = { 1, 2, 1, 2 },
            },
        })
    end,
}
