return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",

  config = function(_)
    local copilot = require "copilot"

    vim.defer_fn(function()
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

      MapKey {
        key = "<leader>lce",
        does = "<cmd>Copilot enable<CR>",
        modes = "n",
      }

      MapKey {
        key = "<leader>lcd",
        does = "<cmd>Copilot disable<cr>",
        modes = "n",
      }

      MapKey {
        key = "<leader>lcp",
        does = "<cmd>Copilot panel<cr>",
        modes = "n",
      }

      MapKey {
        key = "<leader>lct",
        does = "<cmd>Copilot suggestion toggle_auto_trigger<cr>",
        modes = "n",
      }

      MapKey {
        key = "<leader>lcs",
        does = "<cmd>Copilot status<cr>",
        modes = "n",
      }

      Events.await_event {
        actor = "which-key",
        event = "configured",
        callback = function(wk)
          wk.register {
            ["<leader>lc"] = {
              name = "Copilot",
              e = { "<cmd>Copilot enable<CR>", "Enable" },
              d = { "<cmd>Copilot disable<cr>", "Disable" },
              p = { "<cmd>Copilot panel<cr>", "Show Panel" },
              t = { "<cmd>Copilot toggle<cr>", "Toggle Auto Trigger" },
              s = { "<cmd>Copilot status<cr>", "Status" },
            }
          }
        end
      }

    end, 1000)
  end,
}
