-- s = {
--   "<cmd>ClangdSwitchSourceHeader<cr>",
--   "Switch Source/Header Buffers"
-- },
-- p = {
--   "<cmd>ProjectRootToggle<cr>",
--   "Toggle Project AutoRoot"

local default_mappings = {
  f = { name = "Find" },
  -- Buffer Operations
  b = {
    name = "Buffer...",
    d = { "<cmd>Bdelete<cr>", "Delete Buffer (Force)" },
  },
  w = {
    name = "Window...",

    h = { "<cmd>split<cr>", "Split Window Horizontally" },
    v = { "<cmd>vsplit<cr>", "Split Window Vertically" },
    c = { "<cmd>close<cr>", "Close Window" },
    n = { "<cmd>new<cr>", "New Window" },
  },
  l = {
    name = "LSP",

    F = {
      "<cmd>:ToggleAutoFormat<cr>",
      "Toggle AutoFormat"
    },

    H = {
      "<cmd>lua require(\"cmp\").mapping.complete()<cr>",
      "Complete Here"
    },
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
}


return {
  "folke/which-key.nvim",
  -- event = "UIEnter",
  -- key = "*",
  -- keys = { "<leader>", "z", "=" },

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 200
  end,


  config = function()
    local ok, wk = pcall(require, "which-key")

    if not ok then
      vim.notify("Could not import which-key within its own config function!", vim.log.levels.WARN)
      vim.notify("Skipping which-key config; which-key will not be available.", vim.log.levels.WARN)

      Events.fire_event {
        actor = "which-key",
        event = "failed"
      }
      return
    end

    wk.setup {
      plugins = {
        spelling = { enabled = true, },
        -- window = { border = "single", winblend = 10, },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    }

    wk.register(default_mappings, {
      prefix = "<space>",
      mode = "n",
    })

    Events.fire_event {
      actor = "which-key",
      event = "configured",
    }
  end
}
