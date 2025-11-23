return {
    -- Mason (LSP installer)
    -- Manages installing LSP servers, DAP servers, linters and formatters
    -- Like pip but for vim lsp servers
    {
        "mason-org/mason.nvim",
        opts = {}
    },

    -- Mason LSP Config (LSP manager)
    -- Manages running LSP servers
    -- Handles:
    -- i. ensuring lsp servers are installed (via mason.nvim)
    -- ii. ensuring lsp servers are running (via neovim-lspconfig)
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            -- Ensure these LSP servers are installed on startup
            ensure_installed = {
                "lua_ls",
                "basedpyright",
                "ruff",
            },
            -- Automatically enable installed servers
            automatic_enable = true,
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    -- Neovim LSP config (LSP manager)
    -- Handles actually running LSP servers and global LSP settings
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Autocompletion functionality
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Get completion capabilities from nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Global LSP settings (applies to all servers)
            vim.lsp.config("*", {
                -- Project root markers
                root_markers = { '.git' },
                -- Add completion capabilities for all servers
                capabilities = capabilities,
            })

            -- Custom LSP behaviour/operations on current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local opts = { buffer = bufnr, silent = true }

                    -- Keybindings
                    -- Ref: https://neovim.io/doc/user/lsp.html#lsp-buf

                    -- Navigation
                    -- 'gd' - Go to definition
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    -- 'gD' - Go to declaration
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    -- 'gr' - Go to references
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    -- 'gi' - Go to implementation
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

                    -- Info
                    -- 'K' - display hover info about symbol under the cursor
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    -- 'c-k' (insert mode) - display hover info about symbol under the cursor
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

                    -- Actions
                    -- '<leader>rn' - rename all references to the symbol under the cursor
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    -- '<leader>ca' - select a code action available at cursor position
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                    -- '<leader>f' - format buffer using attached LSP 
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)

                    -- Diagnostics (i.e. linting, formatting, errors, etc)
                    -- '[d' - goto previous diagnostic (error) in current buffer
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    -- ']d' - goto next diagnostic (error) in current buffer
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                    -- '<leader>d' - show diagnostics in floating window
                    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)

                end,
              })
        end,
    }
}
