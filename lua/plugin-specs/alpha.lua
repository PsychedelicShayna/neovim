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

  local configure_command = (
    "<cmd>lua vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))<cr>:e .<cr>"
  )

  dashboard.section.header.val = banner
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"
  dashboard.section.buttons.val = {
    dashboard.button("n", "󰻭 New Buffer", "<cmd>ene <bar> startinsert <cr>"),
    dashboard.button("N", "󰝒 New File", ":cd<cr>:ene<cr>:w " .. vim.fn.getcwd() .. "\\"),
    dashboard.button("f", "󰱼 Find File", "<cmd>Telescope find_files <cr>"),
    dashboard.button("t", "󱩾 Live Grep", "<cmd>Telescope live_grep <cr>"),
    dashboard.button("h", " File History", "<cmd>Telescope oldfiles <cr>"),
    dashboard.button("H", "󰥨 Project History ", "<cmd>Telescope projects <cr>"),
    dashboard.button("c", " Configure", configure_command),
    dashboard.button("Q", "󰗼 Exit", "<cmd>qa!<cr>"),
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
