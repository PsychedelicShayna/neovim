local icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
  CmpItemKindCopilot = "",
  Copilot = "",
}

local function config()
  local cmp = require "cmp"

  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },

    performance = {
      throttle = 250
    },

    mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),

      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs( -1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

      ["<C-s>"] = cmp.mapping({
        i = cmp.mapping.complete(),
        c = cmp.mapping.complete(),
      }),

      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),

      ["<C-l>"] = cmp.mapping.confirm({ select = true }),
    },

    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s", icons[vim_item.kind])
        vim_item.menu = ({
              path = "[Path]",
              copilot = "[AI]",
              nvim_lua = "[NVL]",
              nvim_lsp = "[LSP]",
              null_ls = "[NLS]",
              spell = "[Spell]",
              buffer = "[Buffer]",
              cmdline = "[Cmd]"
            })[entry.source.name]
        return vim_item
      end,
    },

    sources = {
      { name = "path" },
      { name = "copilot" },
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      { name = "null-ls" },
      { name = "buffer" },
    },

    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },

    window = {
      completion = cmp.config.window.bordered(), -- TODO: Change to single stroke non-rounded border:
      documentation = cmp.config.window.bordered(),
    },
  }

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources(
      { { name = "cmp_git" } },
      { { name = "buffer" } }
    )
  })
end

return {
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "cmp-path",
      -- "copilot-cmp",
      "cmp-buffer"
    },
    event = "InsertEnter",
    config = config,
  },

  { "hrsh7th/cmp-nvim-lsp",
    lazy = true,
    config = true
  },

  { "hrsh7th/cmp-path",
    lazy = true,
  },

  { "hrsh7th/cmp-buffer",
    keys = { "/", "?" },
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })
    end
  },

  { "hrsh7th/cmp-cmdline",
    dependencies = { "cmp-buffer", "cmp-path" },
    keys = ":",
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline",
            option = {
              ignore_cmds = { "term", "terminal", "Man", "!" }
            }
          },
          { name = "buffer" },
        }
      })
    end,
  },

  { "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    lazy = true,
    config = true,
  }
}
