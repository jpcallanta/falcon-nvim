return { 
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = 'nvim-tree/nvim-web-devicons',

    config = function() 
        require("bufferline").setup {
            options = {
                mode = 'buffers',
                themable = true,
                diagnostics = false,
                numbers = 'none',
                path_components = 1,
                enforce_regular_tabs = true,
                persist_buffer_sort = true,
            }
        }
    end
}

