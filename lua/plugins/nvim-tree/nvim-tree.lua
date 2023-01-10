local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify("Failed to load nvim-tree")
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  vim.notify("Can't load nvim-tree.config")
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1


nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },

  renderer = {
    icons = {
      webdev_colors = true,
      git_placement = "before",

      glyphs = {
        default = "",
        symlink = "",

        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },

        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      }
    },
  },

  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,

  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },

  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },

  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },

  log = {
    enable = false,
    truncate = true,
    types = {
      diagnostics = true,
      git = true,
      profile = true,
      watcher = true
    }
  },

  view = {
    width = 30,
    hide_root_folder = false,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "H", cb = tree_cb "split" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
    number = false,
    relativenumber = true,
  },
}
