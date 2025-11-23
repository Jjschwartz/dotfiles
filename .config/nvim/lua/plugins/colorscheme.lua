return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,  -- load this before everything else
        config = function()
            vim.cmd.colorscheme "catppuccin-mocha"
        end,
    }
}
