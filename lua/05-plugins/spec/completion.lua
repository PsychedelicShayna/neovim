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

-- Alt+hjkl Alt+Shift hjkl 
local function mappings(cmp)
  return {
    ["<A-L>"] = function(_)
      if not cmp.visible() then return cmp.complete() end
      return cmp.confirm()
    end,

    ["<A-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<A-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

    ["<A-H>"] = cmp.mapping.close(),

    ["<A-J>"] = function(_)
      if not cmp.visible_docs() then cmp.open_docs() end
      return cmp.mapping(cmp.scroll_docs(1), { "i", "c" })
    end,

    ["<A-K>"] = function(_)
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

          sources = {
            { name = "path",     option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lsp", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lua", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "null_ls",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "copilot",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
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
          mapping = cmp.mapping.preset.cmdline(),    -- mapping = mappings(cmp),

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
