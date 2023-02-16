return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker"
  },
  lazy = true,
  cmd = { "Neotree", "NeoTreeShowToggle", "NeoTreeFloatToggle" },
  priority = 50,
  config = {
    window = {
      mappings = {
        ["l"] = "toggle_node",
        ["l"] = "open"
      },

      width = 25
    }
  }
}

-- width = 40, -- applies to left and right positions
-- height = 15, -- applies to top and bottom positions
-- auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
-- popup = { -- settings that apply to float position only
-- size = {
--   height = "80%",
--   width = "50%",
-- },
-- position = "50%", -- 50% means center it
-- -- you can also specify border here, if you want a different setting from
-- -- the global popup_border_style.
-- },


