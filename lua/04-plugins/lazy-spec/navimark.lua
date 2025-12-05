return {
  "zongben/navimark.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("navimark").setup {
      keymap = {
        base = {
          -- Base keymaps defined under 07-keymaps/navimark.lua
          ------------------------------------------------------
          ---
          -- MapKey { key = "<leader>ms",  does = "<cmd>lua require('navimark.stack').mark_toggle()<cr>", modes = "n", desc = "Toggle NaviMark" }
          -- MapKey { key = "<leader>ma",  does = "<cmd>lua require('navimark.stack').mark_add()<cr>", modes = "n", desc = "Add NaviMark" }
          -- MapKey { key = "<leader>md",  does = "<cmd>lua require('navimark.stack').mark_remove()<cr>", modes = "n", desc = "Delete NaviMark" }
          -- MapKey { key = "gmn", does = "<cmd>lua require('navimark.stack').goto_next_mark()<cr>", modes = "n", desc = "Next NaviMark" }
          -- MapKey { key = "gmp", does = "<cmd>lua require('navimark.stack').goto_prev_mark()<cr>", modes = "n", desc = "Prev NaviMark" }
          -- MapKey { key = "<leader>mf",  does = "<cmd>lua require('navimark.tele').open_bookmark_picker()<cr>", modes = "n", desc = "Find NaviMark" }
          mark_toggle      = "<leader>mm",
          mark_add         = "<leader>ma",
          mark_remove      = "<leader>md",
          goto_next_mark   = "gmn",
          goto_prev_mark   = "gmp",
          open_mark_picker = "<leader>fm",
        },

        -- telescope = {
        --   -- n = {
        --   --   delete_mark  = "<A-h>",
        --   --   clear_marks  = "<A-H>",
        --   --   new_stack    = "S",
        --   --   next_stack   = "L",
        --   --   prev_stack   = "H",
        --   --   rename_stack = "R",
        --   --   delete_stack = "D",
        --   -- },
        -- },
      },
      sign = {
        text = " ", --        
        color = "#bab6aa",
      },
      persist = true,
    }
  end
}


-- Default config.
-------------------------------------------------------------------------------
-- {
--   keymap = {
--     base = {
--       mark_toggle = "<leader>mm",
--       mark_add = "<leader>ma",
--       mark_remove = "<leader>mr",
--       goto_next_mark = "]m",
--       goto_prev_mark = "[m",
--       open_mark_picker = "<leader>fm",
--     },
--     telescope = {
--       n = {
--         delete_mark = "d",
--         clear_marks = "c",
--         new_stack = "n",
--         next_stack = "<Tab>",
--         prev_stack = "<S-Tab>",
--         rename_stack = "r",
--         delete_stack = "D",
--       },
--     },
--   },
--   sign = {
--     text = "",
--     color = "#FF0000",
--   },
--   persist = false,
-- }
-------------------------------------------------------------------------------
