local events = require("lib.events")

local function which_key_mappings()
  require("which-key").register({
    a = { "<cmd>Alpha<cr>", "Alpha Dashboard" },
  }, {
    mode = "n",
    prefix = "<leader>n"
  })
end

local function config()
  local dashboard = require "alpha.themes.dashboard"
  local banners_ok, banners = pcall(require, "data.banners")

  local banner = {}

  if banners_ok then
    banner = banners['areee??']
  else
    vim.notify("WARNING: Alpha banner defaulting because global.tables.banners could not be imported.")
  end

  dashboard.section.header.val = banner
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New File", "<cmd>ene <BAR> startinsert <cr>"),
    dashboard.button("f", "  Find File", "<cmd>Telescope find_files <cr>"),
    dashboard.button("r", "  Recently Used Files", "<cmd>Telescope oldfiles <cr>"),
    dashboard.button("t", "  Live Grep", "<cmd>Telescope live_grep <cr>"),
    dashboard.button("p", "  Find Project", "<cmd>Telescope projects <cr>"),
    dashboard.button("c", "  Configuration", "<cmd>tcd ~/AppData/Local/nvim | e ~/AppData/Local/nvim/init.lua <cr>"),
    dashboard.button("q", "  Quit Neovim", "<cmd>qa<cr>"),
  }

  dashboard.opts.opts.noautocmd = true

  require("alpha").setup(dashboard.opts)
end

return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-web-devicons" },
  cmd = { "AlphaRedraw", "Alpha" },
  event = function()
    if require("lib.check_greeter_skip")() then
      return {}
    end

    return { "VimEnter" }
  end,
  config = config,
  init = function()
    events.run_after(
      "configured",
      "which-key",
      function()
        which_key_mappings()
      end)
  end,
}
