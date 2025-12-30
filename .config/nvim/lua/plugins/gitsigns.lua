return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening a file
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next Hunk" })

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous Hunk" })

      -- Actions
      map("n", "<leader>hb", function() gs.blame_line { full = true } end, { desc = "Blame Line" })
      map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
      map("n", "<leader>hd", gs.diffthis, { desc = "Diff This" })
      map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
    end,
  },
}
