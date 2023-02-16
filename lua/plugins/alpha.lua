local function config(plugin_spec)
  local dashboard = require "alpha.themes.dashboard"
  local banners = require "tables.banners"

  dashboard.section.header.val = banners.hydra
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
  dependencies = "nvim-tree/nvim-web-devicons",
  config = config,
  event = function(plugin_spec, event)
    if require("utils.check_greeter_skip")() then
      return {}
    end

    return { "VimEnter" }
  end,
  cmd = { "AlphaRedraw", "Alpha" }
}
