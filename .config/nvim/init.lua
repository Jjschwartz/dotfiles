-- Set the Leader key to be space
-- This must occur before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load custom options
require("config.options")

-- Load lazy plugin manager
require("config.lazy")
