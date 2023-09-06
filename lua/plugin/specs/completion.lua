local events = require("prelude").events

-- Variables, Structs, Classes, Functions,
-- Methods, Keywords, Values, Colors, Files,
-- Folders, Operator, Type PArameter
--
-- Optionally:
--  Enum/EnumValue, Constructor (Wrech Ugly Ok)
--
-- Mix Around: Struct, Interface, Class, Enum
-- to find the best looking icons.



local icons = {                      --| Alternative Icons
---------------------------------------|-------------------
                                     --|
  Class                      = " ", --|
  CmpItemKindCopilot         = "󰟶",  --|
  Color                      = "",  --|
  Constant                   = "󰐀",  --|   󰏿 󰐀
  Constructor                = "󱊎",  --| 
  Copilot                    = "󰟶",  --| 
  Enum                       = "",  --| 
  EnumMember                 = "",  --| 󰥣
  Event                      = "",  --|
  Field                      = "",  --|
  File                       = "",  --| 
  Folder                     = "",  --| 󰢰 󱉲
  Function                   = "󰘧",  --| 󰊕 󰡱
  Interface                  = "",  --|
  Keyword                    = "󱘖",  --| 󰮐
  Method                     = "󰡱",  --| 󱄑 󱃸 .󰊕 󰥣
  Module                     = "",  --|   󰏗  
  Operator                   = "",  --| 󰆙
  Property                   = "󱃘",  --|
  Reference                  = "󱃘",  --|
  Snippet                    = "",  --|
  Struct                     = "",  --| 
  Text                       = "",  --| 󰊄
  TypeParameter              = "",  --| 
  Unit                       = "󱂡",  --| 󰆙
  Value                      = "󱛠",  --| 󰅪 󰝨 󰹻
  Variable                   = "󰀫",  --| 
}                                    --|
                                     --|
---------------------------------------|

-- local icons = {
--   Text = "󰊄",
--   Method = "",
--   Function = "",
--   Constructor = "",
--   Field = "",
--   Variable = "",
--   Class = "",
--   Struct = "",
--   Interface = "",
--   Module = "",
--   Property = "",
--   Unit = "",
--   Value = "",
--   Enum = "",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Event = "",
--   Operator = "",
--   TypeParameter = "",
--   CmpItemKindCopilot = "",
--   Copilot = "",
-- }

local function cmp_buffer_size_check(bufnr)
  if type(bufnr) ~= 'number' then
    return {}
  end

  local max_size = 5000 * 1024 -- 5MB
  local nbytes = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))

  local is_very_large = nbytes > max_size

  if is_very_large then
    return {}
  else
    return { bufnr }
  end
end

local function config()
  local cmp = require("cmp")

  cmp.setup {
    snippet = {
      expand = function(args)
        local luasnip_ok, luasnip = pcall(require, 'luasnip')

        if luasnip_ok then
          require('luasnip').lsp_expand(args.body)
        else
          vim.notify('Could not find luasnip, needed by nvim-cmp for expansion of snippets and more!')
          vim.notify('Even if you do not use snippets, downloading luasnip is greatly recommended when using nvim-cmp!')
          DbgNotif('Inspection: ' .. vim.inspect(luasnip))
        end
      end
    },

    performance = {
      throttle         = 50,
      fetching_timeout = 250,
      async_budget     = 5,
      max_view_entries = 50
    },

    completion = {
      keyword_length = 4
    },

    mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),

      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
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
        local icon = icons[vim_item.kind] or vim_item.kind
        vim_item.kind = string.format("%s", icon)

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
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "null-ls" },
      { name = "copilot" },
      {
        name = "buffer",
        { option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
      },
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

  events.fire {
    name = "plugin-loaded",
    category = "nvim-cmp",
    forget = 2
  }
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "cmp-path",
      "copilot-cmp",
      "cmp-buffer",
    },
    event = "InsertEnter",
    config = config,
  },

  {
    "L3MON4D3/LuaSnip",
    lazy = true
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "nvim-cmp" },
    lazy = true,
    config = true
  },

  {
    "hrsh7th/cmp-nvim-lua",
                                    -- ft = "lua",
    lazy = true,
  },

  {
    "hrsh7th/cmp-path",
    lazy = true,
  },

  {
    "hrsh7th/cmp-buffer",
    keys = { "/", "?" },
    lazy = true,
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {
            name = "buffer",
            option = {
              get_bufnrs = cmp_buffer_size_check
            }
          }
        }
      })
    end
  },

  {
    "hrsh7th/cmp-cmdline",
    dependencies = { "nvim-cmp", "cmp-path", }, -- "cmp-buffer" },
    keys = ":",
    lazy = true,
    config = function()
      local cmp = require("cmp")

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "term", "terminal", "Man", "!" }
            }
          },
          {
            name = "buffer",
            option = {
              get_bufnrs = cmp_buffer_size_check
            },
            max_item_count = 20
          },
        }
      })
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "nvim-cmp", "copilot.lua" },
    lazy = true,
    config = true,
  }
}
