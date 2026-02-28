return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-go',
        'nvim-neotest/neotest-python',
    },
    keys = {
        {
            '<leader>tt',
            function()
                require('neotest').run.run()
            end,
            desc = 'Run nearest test',
        },
        {
            '<leader>tF',
            function()
                require('neotest').run.run(vim.fn.expand('%'))
            end,
            desc = 'Run tests in current file',
        },
        {
            '<leader>td',
            function()
                require('neotest').run.run { strategy = 'dap' }
            end,
            desc = 'Debug nearest test',
        },
        {
            '<leader>ts',
            function()
                require('neotest').summary.toggle()
            end,
            desc = 'Toggle test summary',
        },
        {
            '<leader>to',
            function()
                require('neotest').output.open { enter = true, auto_close = true }
            end,
            desc = 'Show test output',
        },
        {
            '<leader>tp',
            function()
                require('neotest').output_panel.toggle()
            end,
            desc = 'Toggle test output panel',
        },
    },
    config = function()
        require('neotest').setup {
            adapters = {
                require('neotest-go')({
                    args = { '-count=1', '-timeout=60s' },
                }),
                require('neotest-python')({
                    dap = { justMyCode = false },
                    args = { '--log-level', 'DEBUG' },
                    runner = 'pytest',
                }),
            },
            diagnostic = {
                enabled = true,
            },
            discovery = {
                enabled = true,
            },
            floating = {
                border = 'rounded',
                max_height = 0.6,
                max_width = 0.6,
            },
            highlight = {
                adapter = 'neotest',
                enabled = true,
            },
            icons = {
                child_indent = '│',
                child_prefix = '├',
                collapsed = '─',
                expanded = '╮',
                failed = '✗',
                final_child_indent = ' ',
                final_child_prefix = '└',
                non_collapsible = '─',
                passed = '✓',
                running = '●',
                skipped = '○',
                unknown = '?',
            },
            output = {
                enabled = true,
                open_on_run = false,
            },
            output_panel = {
                enabled = true,
                open = 'botright split | resize 15',
            },
            projects = {},
            run = {
                enabled = true,
            },
            status = {
                enabled = true,
                signs = true,
                virtual_text = false,
            },
            summary = {
                enabled = true,
                expand_errors = true,
                follow = true,
                mappings = {
                    attach = 'a',
                    expand = { '<CR>', '<2-LeftMouse>' },
                    expand_all = 'e',
                    jumpto = 'i',
                    output = 'o',
                    run = 'r',
                    short = 'O',
                    target = 't',
                },
            },
        }
    end,
}
