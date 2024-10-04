local icons = { --| Alternative Icons -------------------------------------|-------------------
  --|
  -- Class              = "󱃸 ", --|
  -- CmpItemKindCopilot = "󰟶 ", --|
  -- Color              = " ", --|
  -- Constant           = " ", --|   󰏿 󰐀 󰐀
  -- Constructor        = "󱊎 ", --| 
  -- Copilot            = "󰟶 ", --| 
  -- Enum               = "󱄑 ", --| 
  -- EnumMember         = "󰥣 ", --| 
  -- Event              = " ", --| 
  -- Field              = "󱂡 ", --| 󰝨 󰥣 󱂡 󱂡 󰮐
  -- File               = " ", --|  
  -- Folder             = " ", --| 󰢰 󱉲
  -- Function           = "󰘧 ", --| 󰊕 󰡱
  -- Interface          = " ", --| 󱄑
  -- Keyword            = "󱘖 ", --| 󰮐
  -- Method             = "󰡱 ", --| .󰊕
  -- Module             = " ", --|   󰏗  
  -- Operator           = " ", --| 󰆙
  -- Property           = " ", --| 󱃘
  -- Reference          = "󱃘 ", --|
  -- Snippet            = " ", --|  󰢰
  -- Struct             = " ", --|  
  -- Text               = "󰊄 ", --| 
  -- TypeParameter      = " ", --| 
  -- Unit               = "󰆙 ", --| 󰆙 󱂡
  -- Value              = "󱛠 ", --| 󰅪 󰝨 󰹻
  -- Variable           = "󰀫 ", --|
}

local function cmp_buffer_size_check(bufnr)
  if type(bufnr) ~= 'number' then
    return {}
  end

  local max_size = 500 * 1024 -- 500KB
  local nbytes = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))

  local is_very_large = nbytes > max_size

  if is_very_large then
    return {}
  else
    return { bufnr }
  end
end


-- Alt+hjkl Alt+Shift hjkl
local function mappings(_)
  local cmp = require 'cmp'

  return {
    ["<A-i>"] = function(_)
      if not cmp.visible() then
        return cmp.complete()
      else
        return cmp.close()
      end
    end,

    ["<A-l>"] = function(fallback)
      if not cmp.visible() then return fallback() end
      return cmp.mapping(cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert }))
    end,

    ["<A-h>"] = function(fallback)
      if not cmp.visible() then return fallback() end
      if not cmp.visible_docs() then return cmp.open_docs() end
    end,

    ["<A-k>"] = function(fallback)
      if not cmp.visible() then return fallback() end
      return cmp.mapping(cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }))
    end,

    ["<A-j>"] = function(fallback)
      if not cmp.visible() then return fallback() end
      return cmp.mapping(cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }))
    end,


    ["<A-J>"] = function(fallback)
      if not cmp.visible() or not cmp.visible_docs() then
        return fallback()
      end

      return cmp.mapping(cmp.scroll_docs(1), { "i", "c" })
    end,

    ["<A-K>"] = function(fallback)
      if not cmp.visible() or not cmp.visible_docs() then
        return fallback()
      end

      return cmp.mapping(cmp.scroll_docs(-1), { "i", "c" })
    end,
  }
end

return {
  {
    "hrsh7th/cmp-nvim-lua",
    lazy = true,
    ft = 'lua'
  },

  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
    event = "CmdlineEnter"
  },

  {
    "hrsh7th/cmp-path",
    lazy = true,
    event = { "InsertEnter", "CmdlineEnter" }
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
    event = { "Syntax" }
  },

  -- {
  --   "hrsh7th/cmp-buffer",
  --   lazy = true,
  --   event = { "InsertEnter" }
  -- },


  -- {
  --   "zbirenbaum/copilot-cmp",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   lazy = true,
  --   init = function()
  --     Events.await_event {
  --       actor = "copilot",
  --       event = "configured",
  --       callback = function()
  --         require('copilot_cmp')
  --       end
  --     }
  --   end
  -- },

  {
    -- "hrsh7th/nvim-cmp",
    "yioneko/nvim-cmp", -- Fork with faster performance.
    branch = "perf",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },

    config = function()
      Safe.import_then('cmp', function(cmp)
        cmp.setup {
          snippet = {
            expand = function(args)
              Safe.import_then('luasnip', function(lsnip)
                return lsnip.lsp_expand(args.body)
              end)
            end
          },

          view = { entries = { name = 'custom', selection_order = 'top_down' },
            docs = { auto_open = false, },
          },

          performance = {
            fetching_timeout = 50,
            max_view_entries = 20
          },

          sources = {
            { name = "path",     option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lsp", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lua", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "null_ls",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "copilot",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "buffer",   option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
          },

          -- sorting = {
          --   priority_weight = 4,
          --   comparators = {
          --     cmp.compare.exact,
          --     cmp.compare.score,
          --     cmp.compare.recently_used,
          --     cmp.compare.locality,
          --     cmp.compare.scopes,
          --     cmp.compare.kind,
          --     cmp.compare.order,
          --     cmp.compare.offset,
          --     cmp.compare.length,
          --     -- cmp.compare.sort_text,
          --   },
          -- },

          window = {
            completion = cmp.config.window.bordered { border = 'single', scrollbar = false },
            documentation = { border = 'single', }
          },

          mapping = mappings(cmp),
        }

        cmp.setup.cmdline(":", {
          mapping = cmp.mapping.preset.cmdline(), -- mapping = mappings(cmp),

          sources = cmp.config.sources {
            { name = "cmdline" },
            { name = "path" }
          },

          performance = {
            fetching_timeout = 100,
            max_view_entries = 10
          },
        })

        Events.fire_event {
          actor = "nvim-cmp",
          event = "configured"
        }
      end)
    end
  }
}
