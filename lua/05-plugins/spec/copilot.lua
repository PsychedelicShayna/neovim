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
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>"
        },

        layout = {
          position = "top",
          ratio = 0.3
        },

        suggestion = {
          enable = true,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<A-S-Enter>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>"
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
    end, 1000)
  end,
}
