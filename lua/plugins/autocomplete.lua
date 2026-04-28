return { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
        {
            'folke/lazydev.nvim',
            config = function()
                require('lazydev').setup()
            end,
        },
    },
    opts = {
        keymap = {
            preset = 'default',
            ['<CR>'] = { 'accept', 'fallback' },
        },

        appearance = {
            nerd_font_variant = 'mono',
        },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 300 },
        },

        sources = {
            default = { 'lsp', 'path', 'lazydev' },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
        },

        fuzzy = { implementation = 'lua' },
        signature = { enabled = true },
    },
}


