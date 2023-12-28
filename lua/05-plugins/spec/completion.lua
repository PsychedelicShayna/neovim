local icons = { --| Alternative Icons -------------------------------------|-------------------
  --|
  Class              = "󱃸 ", --|
  CmpItemKindCopilot = "󰟶 ", --|
  Color              = " ", --|
  Constant           = " ", --|   󰏿 󰐀 󰐀
  Constructor        = "󱊎 ", --| 
  Copilot            = "󰟶 ", --| 
  Enum               = "󱄑 ", --| 
  EnumMember         = "󰥣 ", --| 
  Event              = " ", --| 
  Field              = "󱂡 ", --| 󰝨 󰥣 󱂡 󱂡 󰮐
  File               = " ", --|  
  Folder             = " ", --| 󰢰 󱉲
  Function           = "󰘧 ", --| 󰊕 󰡱
  Interface          = " ", --| 󱄑
  Keyword            = "󱘖 ", --| 󰮐
  Method             = "󰡱 ", --| .󰊕
  Module             = " ", --|   󰏗  
  Operator           = " ", --| 󰆙
  Property           = " ", --| 󱃘
  Reference          = "󱃘 ", --|
  Snippet            = " ", --|  󰢰
  Struct             = " ", --|  
  Text               = "󰊄 ", --| 
  TypeParameter      = " ", --| 
  Unit               = "󰆙 ", --| 󰆙 󱂡
  Value              = "󱛠 ", --| 󰅪 󰝨 󰹻
  Variable           = "󰀫 ", --|
}





local function cmp_buffer_size_check(bufnr)
  if type(bufnr) ~= 'number' then
    return {}
  end

  local max_size = 1000 * 1024 -- 1MB
  local nbytes = vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))

  local is_very_large = nbytes > max_size

  if is_very_large then
    return {}
  else
    return { bufnr }
  end
end

local entered_completion = false
local navigation_toggle = false

-- Alt+hjkl Alt+Shift hjkl
local function mappings(_)
  local cmp = require 'cmp'

  return {
    ["<A-i>"] = function(fallback)
      if not cmp.visible() then
        cmp.complete()
        return
      elseif not navigation_toggle then
        navigation_toggle = true
      end
    end,

    ["i"] = function(fallback)
      if not cmp.visible() or not navigation_toggle then
        fallback()
      else
        navigation_toggle = false
      end
    end,

    ["<A-l>"] = function(fallback)
      if not cmp.visible() or navigation_toggle then
        return fallback()
      end
      
      return cmp.mapping(cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }))
    end,

    ["<A-h>"] = function(fallback)
      if cmp.visible() and not navigation_toggle then
        navigation_toggle = false
        cmp.close()
        return
      end

      fallback()
    end,

    ["<A-k>"] = function(fallback)
      if not cmp.visible() or navigation_toggle then
        return fallback()
      end

      return cmp.mapping(cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }))
    end,

    ["<A-j>"] = function(fallback)
      if not cmp.visible() or navigation_toggle then
        return fallback()
      end

        return cmp.mapping(cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }))
    end,

    ["l"] = function(fallback)
      if cmp.visible() and navigation_toggle then
        navigation_toggle = false
        return cmp.mapping(cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }))
      end

      fallback()
    end,

    ["h"] = function(fallback)
      if cmp.visible() and navigation_toggle then
        navigation_toggle = false
        cmp.close()
        return
      end

      fallback()
    end,

    ["k"] = function(fallback)
      if cmp.visible() and navigation_toggle then
        return cmp.mapping(cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }))
      end

      fallback()
    end,

    ["j"] = function(fallback)
      if cmp.visible() and navigation_toggle then
        return cmp.mapping(cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }))
      end

      fallback()
    end,
    ["J"] = function(fallback)
      if not cmp.visible() or not navigation_toggle then
        return fallback()
      end

      if not cmp.visible_docs() then cmp.open_docs() end
      return cmp.mapping(cmp.scroll_docs(1), { "i", "c" })
    end,

    ["H"] = function(fallback)
      if not cmp.visible() or not navigation_toggle then
        return fallback()
      end

      if not cmp.visible_docs() then cmp.open_docs() end
      return cmp.mapping(cmp.scroll_docs(-1), { "i", "c" })
    end,

    ["<A-J>"] = function(fallback)
      if not cmp.visible() or navigation_toggle then
        return fallback()
      end

      if not cmp.visible_docs() then cmp.open_docs() end
      return cmp.mapping(cmp.scroll_docs(1), { "i", "c" })
    end,

    ["<A-H>"] = function(fallback)
      if not cmp.visible() or navigation_toggle then
        return fallback()
      end

      if not cmp.visible_docs() then cmp.open_docs() end
      return cmp.mapping(cmp.scroll_docs(-1), { "i", "c" })
    end,


  }
end

return {

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      { "zbirenbaum/copilot-cmp", dependencies = { "zbirenbaum/copilot.lua" } },
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
          --     cmp.compare.score,
          --     cmp.compare.kind,
          --     cmp.compare.order,
          --     cmp.compare.recently_used,
          --     cmp.compare.exact,
          --     cmp.compare.offset,
          --     cmp.compare.scopes,
          --     cmp.compare.locality,
          --     -- cmp.compare.sort_text,
          --     cmp.compare.length,
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
