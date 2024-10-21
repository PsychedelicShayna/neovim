return {
  "folke/which-key.nvim",
  -- event = "UIEnter",
  -- key = "*",
  keys = { "<leader>", "z", "=", '"', '`', 'g', ']', '[', 'v' },

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 200
  end,

  config = function()
    local ok, wk = pcall(require, "which-key")

    if not ok then
      vim.notify("Could not import which-key within its own config function!", vim.log.levels.WARN)
      vim.notify("Skipping which-key config; which-key will not be available.", vim.log.levels.WARN)
      Events.fire_event { actor = "which-key", event = "failed" }
      return
    end

    wk.setup {
      preset = 'helix',
      win = {
        title = true,
        title_pos = "center",
        border = "single",
        padding = { 1, 2 }
      },
      plugins = {
        spelling = { enabled = true, },
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

      icons = {
        mappings = false,
        group = ''
      }
    }

    Events.fire_event { actor = "which-key", event = "configured", }
  end
}
