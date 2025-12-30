return {
    "nvim-tree/nvim-tree.lua",
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

            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {},
            },

            renderer = {
                group_empty = true,
                icons = {  -- disable icons
                    show = {
                        file = false,
                        folder = false,
                        -- keep dir arrow for collapsing/expanding
                        folder_arrow = true,   
                        git = false,
                    },
                    glyphs = {
                        folder = {
                            arrow_closed = "▸",
                            arrow_open = "▾",
                        },
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
    end
}
