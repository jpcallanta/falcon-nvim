return {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
        -- 'soft' variant of the dark palette
        vim.g.gruvbox_material_foreground = 'soft'
        vim.g.gruvbox_material_background = 'dark'
        vim.g.gruvbox_material_transparent_background = 1 -- match catppuccin transparency
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_better_performance = 1
        vim.cmd.colorscheme 'gruvbox-material'
    end
}
