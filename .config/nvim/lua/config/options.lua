-- lua/config/options.lua
local opt = vim.opt

-- Line numbers (Hybrid: shows absolute line number at cursor, relative elsewhere)
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8           -- Keep 8 lines below/above cursor
opt.sidescrolloff = 8       -- Keep 8 columns left/right of cursor (for horizontal)

-- Indentation 
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true   -- change tabs to spaces
opt.autoindent = true

-- Clipboard (Sync with OS clipboard)
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true  -- case sensitive only if you type a capital letter

-- UI polish
opt.termguicolors = true   -- True color support
opt.signcolumn = "yes"     -- Keep space for linting icons (stops shifting)
opt.splitbelow = true      -- New horizontal splits go down
opt.splitright = true      -- New vertical splits go right
