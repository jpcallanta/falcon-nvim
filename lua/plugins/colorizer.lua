return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = { -- set to setup table
    },
    config = function()
        require("colorizer").setup {
            lazy_load = true,

        }
    end
}
