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
  local banners_ok, banners = pcall(require, "global.tables.banners")

  local banner = {}

  if banners_ok then
    banner = banners.hydra
  else
    vim.notify("WARNING: Alpha banner defaulting because global.tables.banners could not be imported.")
  end

  dashboard.section.header.val = banner
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
    dashboard.button("r", "  Recently Used Files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", "  Live Grep", ":Telescope live_grep <CR>"),
    dashboard.button("p", "  Find Project", ":Telescope projects <CR>"),
    dashboard.button("c", "  Configuration", ":e ~/AppData/Local/nvim <CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
  }

  dashboard.opts.opts.noautocmd = true

  require("alpha").setup(dashboard.opts)
end

return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-web-devicons" },
  cmd = { "AlphaRedraw", "Alpha" },
  event = function()
    if require("utils.check_greeter_skip")() then
      return {}
    end

    return { "VimEnter" }
  end,
  config = config,
  init = function()
    require("global.control.events").new_cb_or_call(
      "plugin-loaded",
      "which-key",
      function()
        which_key_mappings()
      end)
  end,
}
