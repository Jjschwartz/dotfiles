-- lua/config/keymaps.lua

-- Move lines up/down
-- Normal
vim.keymap.set("n", "<M-k>", ":m -2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<M-j>", ":m +1<CR>==", { desc = "Move line down" })

-- Visual
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

-- Insert
vim.keymap.set("i", "<M-j>", "<Esc>:m +1<CR>==gi", { desc = "Move line up" })
vim.keymap.set("i", "<M-k>", "<Esc>:m -2<CR>==gi", { desc = "Move line down" })
