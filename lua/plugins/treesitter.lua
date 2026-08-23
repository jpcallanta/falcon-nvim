return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        -- Use gcc instead of cl.exe on Windows
        require("nvim-treesitter.install").compilers = { "gcc" }

        require('nvim-treesitter').setup {
            install_dir = vim.fn.stdpath('data') .. '/site',
        }

        -- Install parsers
        require('nvim-treesitter').install {
            'odin',
            'go',
            'python',
            'markdown',
            'markdown_inline',
            'json',
            'xml',
            'typescript',
            'javascript',
            'make',
            'yaml',
        }

        -- Enable treesitter highlighting
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                'odin',
                'go',
                'python',
                'markdown',
                'json',
                'xml',
                'typescript',
                'javascript',
                'make',
                'yaml',
            },
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
