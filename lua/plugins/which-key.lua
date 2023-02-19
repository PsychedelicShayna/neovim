local default_mappings = {
  f = { name = "Find" },
  -- Buffer Operations
  b = {
    name = "Buffer...",
    d = { "<cmd>Bdelete<cr>", "Delete Buffer (Force)" },
    -- s = {
    --   "<cmd>ClangdSwitchSourceHeader<cr>",
    --   "Switch Source/Header Buffers"
    -- },
    -- p = {
    --   "<cmd>ProjectRootToggle<cr>",
    --   "Toggle Project AutoRoot"
  },
  w = {
    name = "Window...",

    h = { "<cmd>split<cr>", "Split Window Horizontally" },
    v = { "<cmd>vsplit<cr>", "Split Window Vertically" },
    c = { "<cmd>close<cr>", "Close Window" },
    n = { "<cmd>new<cr>", "New Window" },
  },
  l = {
    name = "LSP...",
  },
  c = {
    name = "Neovim Control...",
    m = { "<cmd>Mason<cr>", "Mason" },
    l = { "<cmd>Lazy<cr>", "Lazy" },
    c = { "<cmd>e ~/AppData/Local/nvim<cr>", "Configuration" }
  },
  d = {
    name = "Diagnostics...",
    j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next", },
    k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous", },
    l = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Location List", },
  },
  -- LSP Server
  -- l = {
  --   name = "LSP",
  --   F = {
  --     "<cmd>:ToggleAutoFormat<cr>",
  --     "Toggle AutoFormat"
  --   },
  --
  --   H = {
  --     "<cmd>lua require(\"cmp\").mapping.complete()<cr>",
  --     "Complete Here"
  --   },
  --
}

return {
  "folke/which-key.nvim",
  -- event = "UIEnter",
  keys = "<leader>",
  lazy = true,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local which_key = require("which-key")

    which_key.setup {
      plugins = {
        spelling = {
          enabled = true,
        },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = true,
          nav = true,
          z = true,
          g = false,
        },
      },

      window = {
        border = "single",
        winblend = 10,
      },

      ignore_missing = true,
    }

    which_key.register(default_mappings, {
      prefix = "<space>",
      mode = "n",
    })

    require("global.control.events").fire("plugin-loaded", "which-key", 2)
  end
}
