return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        ensure_installed = { "python", "lua", "vim", "vimdoc", "markdown" },
        -- Highlight based on the parser
        highlight = { enable = true },
        -- Indentation based on the parser
        indent = { enable = true },
      })
    end
  }
}
