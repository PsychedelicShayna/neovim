local events = require("prelude").events

local aa_dragons_ok, aa_dragons = pcall(require, 'const.ascii-art.dragons')
local aa_skulls_ok, aa_skulls = pcall(require, 'const.ascii-art.skulls')
local aa_critters_ok, aa_critters = pcall(require, 'const.ascii-art.critters')

local function which_key_mappings()
  require('which-key').register({
    a = { "<cmd>Alpha<cr>", "Alpha Dashboard" },
  }, {
    mode = "n",
    prefix = "<leader>n"
  })
end

local function config()
  local dashboard = require "alpha.themes.dashboard"
  local banner = {}

  if aa_critters_ok then
    banner = aa_critters.poesidon
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
    if plNvimGetDirectlyOpened() then
      return {}
    end

    -- if require("prelude").check_greeter_skip() then
    --   return {}
    -- end

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
