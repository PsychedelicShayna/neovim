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
          mark_toggle      = nil,
          mark_add         = nil,
          mark_remove      = nil,
          goto_next_mark   = nil,
          goto_prev_mark   = nil,
          open_mark_picker = nil,
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
        text = " ", --        
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
