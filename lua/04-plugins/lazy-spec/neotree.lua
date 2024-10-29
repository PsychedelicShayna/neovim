local function config()
  require("neo-tree").setup {
    use_default_mappings = false,

    sources = {
      "filesystem",
      "document_symbols",
      "buffers"
    },

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

    buffers = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,          -- This will find and focus the file in the active buffer every time
        -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },

      group_empty_dirs = true,   -- when true, empty directories will be grouped together

      -- When working with sessions, for example, restored but unfocused buffers
      -- are mark as "unloaded". Turn this on to view these unloaded buffer.
      show_unloaded = true,

      terminals_first = true, -- when true, terminals will be listed before file buffers

      window = {
        mappings = {
          ["h"] = "navigate_up",
          ["<A-h>"] = "set_root",
          ["d"] = "buffer_delete",
          ["i"] = "show_file_details",
          ["?"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["sc"] = { "order_by_created", nowait = false },
          ["sd"] = { "order_by_diagnostics", nowait = false },
          ["sm"] = { "order_by_modified", nowait = false },
          ["sn"] = { "order_by_name", nowait = false },
          ["ss"] = { "order_by_size", nowait = false },
          ["st"] = { "order_by_type", nowait = false },
        },
      },
    },

    filesystem = {
      hijack_netrw_behavior = "disabled",
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          -- Opening files different ways.
          ["l"] = "open_with_window_picker",
          ["e"] = "open",
          ["v"] = "vsplit_with_window_picker",
          ["s"] = "split_with_window_picker",

          --  IO Operations / cp, rm, mv, mkdir, touch
          ["a"] = { "add", config = { show_path = "relative" } },
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["C"] = "copy",
          ["x"] = "cut_to_clipboard",
          ["X"] = "move",
          ["p"] = "paste_from_clipboard",

          -- UI / Navigation / Other Stuff
          ["h"] = "navigate_up",
          ["<A-h>"] = "set_root",
          ["f"] = "filter_on_submit",
          ["F"] = "clear_filter",
          ["."] = "toggle_hidden",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      }
    },

    async_directory_scan = "always",

    filtered_items = {
      hide_dotfilees = false,
      hide_hidden = false,
    }
  }
end

local function which_key_mappings()
  require("which-key").add {
    { "<leader>E",  group = "[NeoTree]" },
    { "<leader>Ef", "<cmd>Neotree focus<cr>",  desc = "Focus" },
    { "<leader>Ej", "<cmd>Neotree left<cr>",   desc = "Left Mode" },
    { "<leader>Ek", "<cmd>Neotree float<cr>",  desc = "Center Mode" },
    { "<leader>El", "<cmd>Neotree right<cr>",  desc = "Right Mode" },
    { "<leader>Et", "<cmd>Neotree top<cr>",    desc = "Top Mode" },
    { "<leader>e",  "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
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
