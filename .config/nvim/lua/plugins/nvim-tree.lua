return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",  -- Optional: for file icons
    },
    config = function ()
        -- Disable netrw (Neovim's built-in file explorer)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
                folders_first = true,
            },

            view = {
                width = 30,
                side = "left",
                relativenumber = true,
            },

            renderer = {
                group_empty = true,
                icons = {
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
            filters = {
                dotfiles = false,  -- Show hidden files
                custom = { "^.git$" },  -- Hide .git folder
            },
            git = {
                enable = true,
                ignore = false,  -- Show gitignored files
            },
        })

        -- Keybindings
        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle file explorer' })
        vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeFocus<cr>', { desc = 'Focus file explorer' })
        vim.keymap.set('n', '<leader>ff', '<cmd>NvimTreeFindFile<cr>', { desc = 'Find current file in explorer' })
    end
}
