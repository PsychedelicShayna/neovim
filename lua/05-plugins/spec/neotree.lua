local function config()
  require("neo-tree").setup {
    use_default_mappings = false,

    default_component_configs = {
      git_status = {
        symbols = {
          added     = "✚",
          deleted   = "✖",
          modified  = "",
          renamed   = "",

          unstaged  = "u",
          staged    = "S",
          unmerged  = "",
          untracked = "U",
          ignored   = "◌",
        },
      },
      indent = {
        with_markers = true,
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        indent_marker = "│",
        last_indent_marker = "└",
        indent_size = 2,
      },
    },

    window = {
      width = 25,
      mappings = {
        ["H"] = "prev_source",
        ["L"] = "next_source",
      }
    },

    filesystem = {
      hijack_netrw_behavior = "open_default",
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          -- Navigation
          ["l"] = "open",
          ["K"] = "navigate_up",
          ["t"] = "set_root",

          -- Filtering
          ["F"] = "clear_filter",
          ["f"] = "filter_on_submit",
          ["."] = "toggle_hidden",

          -- UI
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["p"] = { "toggle_preview", config = { use_float = true } },

          -- File Actions
          ["v"] = "vsplit_with_window_picker",
          ["h"] = "split_with_window_picker",
          ["W"] = "open_with_window_picker",

          ["a"] = { "add", config = { show_path = "relative" } },
          ["d"] = "delete",
          ["r"] = "rename",

          -- Clipboard actions.
          ["c"] = "copy_to_clipboard",
          ["C"] = "copy",
          ["x"] = "cut_to_clipboard",
          ["X"] = "move",
          ["P"] = "paste_from_clipboard",
        },
      }
    },
  }
end

local function which_key_mappings()
  require("which-key").add {
    { "<leader>E", group = "[NeoTree]" },
    { "<leader>Ef", "<cmd>Neotree focus<cr>", desc = "Focus" },
    { "<leader>Ej", "<cmd>Neotree left<cr>", desc = "Left Mode" },
    { "<leader>Ek", "<cmd>Neotree float<cr>", desc = "Center Mode" },
    { "<leader>El", "<cmd>Neotree right<cr>", desc = "Right Mode" },
    { "<leader>Et", "<cmd>Neotree top<cr>", desc = "Top Mode" },
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
    --
    --
    -- ["e"] = {
    --   "<cmd>Neotree toggle<cr>",
    --   "NeoTree Toggle"
    -- },
    -- E = {
    --   name = "[NeoTree]",
    --
    --   k = {
    --     "<cmd>Neotree float<cr>",
    --     "Center Mode"
    --   },
    --
    --   l = {
    --     "<cmd>Neotree right<cr>",
    --     "Right Mode"
    --   },
    --
    --   j = {
    --     "<cmd>Neotree left<cr>",
    --     "Left Mode"
    --   },
    --   t = {
    --     "<cmd>Neotree top<cr>",
    --     "Top Mode"
    --   },
    --
    --   f = {
    --     "<cmd>Neotree focus<cr>",
    --     "Focus"
    --   }
    -- }
  } -- , {
  --   mode = "n",
  --   prefix = "<leader>"
  -- })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "s1n7ax/nvim-window-picker",
  },
  lazy = true,
  cmd = "Neotree",
  config = config,
  init = function()
    Events.await_event {
      actor = "which-key",
      event = "configured",
      retroactive = true,
      callback = function()
        which_key_mappings()
      end
    }
  end,
}
