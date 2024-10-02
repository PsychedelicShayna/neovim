return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-web-devicons" },
  cmd = { "AlphaRedraw", "Alpha" },

  event = function()
    if UsrLib.check_greeter_skip() then return {} end
    return { "VimEnter" }
  end,

  config = function()
    local banner_name = 'areee??'

    local banner = Safe.ok_or_else(
      function(name) -- Ok
        return Data.banners[name]
      end,

      function(okv, modv, name) -- Err
        PrintDbg('WARNING [alpha.lua]: Failed to get banner "' .. name
          .. '", defaulted to an empty table instead.',
          LL_WARN, { okv, modv, args }
        )
        return {}
      end,

      banner_name
    )

    local dashboard = require "alpha.themes.dashboard"

    dashboard.section.header.val = banner
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.section.buttons.val = {
      dashboard.button("n", "󰻭 New Buffer", "<cmd>ene <bar> startinsert <cr>"),
      dashboard.button("N", "󰝒 New File", ":cd<cr>:ene<cr>:w " .. vim.fn.getcwd() .. "\\"),
      dashboard.button("f", "󰱼 Find File", "<cmd>Telescope find_files <cr>"),
      dashboard.button("t", "󱩾 Live Grep", "<cmd>Telescope live_grep <cr>"),
      dashboard.button("r", " File History", "<cmd>Telescope oldfiles <cr>"),
      dashboard.button("c", " Configure", "<cmd>lua vim.api.nvim_set_current_dir(vim.fn.stdpath('config'))<cr>:e .<cr>"),
      dashboard.button("x", "󰗼 Exit", "<cmd>qa!<cr>"),
    }

    dashboard.opts.opts.noautocmd = true
    require("alpha").setup(dashboard.opts)
  end,

  init = function()
    Safe.try_catch(function()
      Events.await_event {
        actor = "which-key",
        event = "configured",
        retroactive = true,
        callback = function()
          Safe.try(function()
            require('which-key').add {
              "<leader>bh", "<cmd>Alpha<cr>", desc = "Alpha Dashboard"
            }
          end)
        end
      }
    end)
  end
}
