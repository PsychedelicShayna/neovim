return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  init = function()
    Events.await_event {
      actor = "which-key",
      event = "configured",
      retroactive = true,
      callback = function()
        Safe.import_then('which-key', function(wk)
          wk.add {
            { "<leader>lc",  group = "[Copilot]" },
            { "<leader>lce", "<cmd>Copilot enable<cr>",     desc = "Enable" },
            { "<leader>lcd", "<cmd>Copilot disable<cr>",    desc = "Disable" },
            { "<leader>lcp", "<cmd>Copilot panel<cr>",      desc = "Show Panel" },
            { "<leader>lct", "<cmd>Copilot toggle<cr>",     desc = "Toggle Auto Trigger" },
            { "<leader>lcs", "<cmd>Copilot suggestion<cr>", desc = "Suggestions" },
            { "<leader>lcS", "<cmd>Copilot status<cr>",     desc = "Status" },
          }
        end)
      end
    }
  end,

  config = function(_)
    local copilot = require "copilot"

    copilot.setup {
      auto_refresh = false,

      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<C-M-Enter>",
        refresh = "gr",
        open = "<C-M-CR>"
      },

      layout = {
        position = "top",
        ratio = 0.3
      },

      suggestion = {
        enable = false,
        auto_trigger = false,
        debounce = 75,
        keymap = {
          accept = "<A-L>",
          next = "<A-K>",
          prev = "<A-J>",
          dismiss = "<A-H>"
        }
      },

      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        json = false,
        krypt = false,
        gpg = false,
        pgp = false,
        cert = false,
        crt = false,
        pem = false,
        txt = false
      },
    }
  end,

  Events.fire_event {
    actor = "copilot",
    event = "configured"
  }
}
