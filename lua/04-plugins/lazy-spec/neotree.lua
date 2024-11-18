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
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },

      group_empty_dirs = true, -- when true, empty directories will be grouped together

      -- When working with sessions, for example, restored but unfocused buffers
      -- are mark as "unloaded". Turn this on to view these unloaded buffer.
      show_unloaded = true,

      terminals_first = true, -- when true, terminals will be listed before file buffers

      window = {
        mappings = {
          ["."] = "toggle_hidden",
          ["<2-LeftMouse>"] = "open",
          ["<esc>"] = "revert_preview",
          ["?"] = "show_help",
          ["C"] = "copy",
          ["F"] = "clear_filter",
          ["K"] = "navigate_up",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["R"] = "refresh",
          ["X"] = "move",
          ["l"] = "open",
          ["\\c"] = "close_all_nodes",
          ["\\e"] = "expand_all_nodes",
          ["\\s"] = "close_all_subnodes",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["c"] = "copy_to_clipboard",
          ["d"] = "delete",
          ["w"] = "open_with_window_picker",
          ["f"] = "filter_on_submit",
          ["i"] = "show_file_details",
          ["e"] = "open",
          ["m"] = "move",
          ["oc"] = "order_by_created",
          ["od"] = "order_by_diagnostics",
          ["og"] = "order_by_git_status",
          ["om"] = "order_by_modified",
          ["on"] = "order_by_name",
          ["os"] = "order_by_size",
          ["ot"] = "order_by_type",
          ["p"] = "paste_from_clipboard",
          ["r"] = "rename",
          ["t"] = "set_root",
          ["s"] = "split_with_window_picker",
          ["v"] = "vsplit_with_window_picker",
          ["x"] = "cut_to_clipboard",
        },
      },
    },

    filesystem = {
      hijack_netrw_behavior = "disabled",
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      follow_current_file = { enabled = true },
      window = {
        mappings = {
          ["."] = "toggle_hidden",
          ["<2-LeftMouse>"] = "open",
          ["<esc>"] = "revert_preview",
          ["?"] = "show_help",
          ["C"] = "copy",
          ["F"] = "clear_filter",
          ["K"] = "navigate_up",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["R"] = "refresh",
          ["X"] = "move",
          ["l"] = "open",
          ["\\c"] = "close_all_nodes",
          ["\\e"] = "expand_all_nodes",
          ["\\s"] = "close_all_subnodes",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["c"] = "copy_to_clipboard",
          ["d"] = "delete",
          ["w"] = "open_with_window_picker",
          ["f"] = "filter_on_submit",
          ["i"] = "show_file_details",
          ["e"] = "open",
          ["m"] = "move",
          ["oc"] = "order_by_created",
          ["od"] = "order_by_diagnostics",
          ["og"] = "order_by_git_status",
          ["om"] = "order_by_modified",
          ["on"] = "order_by_name",
          ["os"] = "order_by_size",
          ["ot"] = "order_by_type",
          ["p"] = "paste_from_clipboard",
          ["r"] = "rename",
          ["t"] = "set_root",
          ["s"] = "split_with_window_picker",
          ["v"] = "vsplit_with_window_picker",
          ["x"] = "cut_to_clipboard",
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
