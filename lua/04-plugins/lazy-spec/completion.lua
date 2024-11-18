local icons = { --| Alternative Icons -------------------------------------|-------------------
  Class              = " ", --| 󱃸
  CmpItemKindCopilot = "󰟶 ", --|
  Color              = " ", --|
  Constant           = " ", --|   󰏿 󰐀 󰐀
  Constructor        = "󱊎 ", --| 
  Copilot            = "󰟶 ", --| 
  Enum               = " ", --|  󱄑
  EnumMember         = "󰥣 ", --| 
  Event              = " ", --| 
  Field              = "󱂡 ", --| 󰝨 󰥣 󱂡 󱂡 󰮐
  File               = " ", --|  
  Folder             = " ", --| 󰢰 󱉲
  Function           = "󰊕", --| 󰊕 󰡱 󰘧
  Interface          = " ", --| 󱄑
  Keyword            = "󰮐", --| 󰮐 󱘖
  Method             = "󰡱 ", --|  󰡱
  Module             = " ", --|   󰏗  
  Operator           = " ", --| 󰆙
  Property           = " ", --| 󱃘
  Reference          = "󱃘 ", --|
  Snippet            = " ", --|  󰢰 
  Struct             = " ", --|  
  Text               = "", --|  󰊄
  TypeParameter      = " ", --| 
  Unit               = "󰆙 ", --| 󰆙 󱂡
  Value              = "󱛠 ", --| 󰅪 󰝨 󰹻
  Variable           = "󰀫", --|
}

local function cmp_buffer_size_check()
  local bufnr = vim.api.nvim_get_current_buf()

  local buffer_size = vim.api.nvim_buf_get_offset(
    bufnr, vim.api.nvim_buf_line_count(bufnr)
  )

  local size_limit = (1024 * 1024) * 5 -- 5MB

  if buffer_size > size_limit then
    return {}
  else
    return { bufnr }
  end
end


-- Alt+hjkl Alt+Shift hjkl
local function mappings(cmp)
  local ls = require("luasnip")

  return {
    ["<A-i>"] = function(_)
      if not cmp.visible() then
        return cmp.mapping(cmp.complete(), { 'i', 'n' })
      else
        return cmp.close()
      end
    end,

    ["<A-l>"] = function(fallback)
      if cmp.visible() then
        return cmp.mapping(cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert }))
      elseif ls.expandable() then
        return cmp.mapping(ls.expand())
      else
        fallback()
      end
    end,

    ["<A-h>"] = function(fallback)
      if not cmp.visible() then return fallback() end
      if not cmp.visible_docs() then return cmp.open_docs() end
    end,

    ["<A-k>"] = function(fallback)
      if cmp.visible() then
        return cmp.mapping(cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }))
      elseif ls.locally_jumpable(-1) then
        return cmp.mapping(ls.jump(-1), { 'i', 's' })
      else
        return fallback()
      end
    end,

    ["<A-j>"] = function(fallback)
      if cmp.visible() then
        return cmp.mapping(cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }))
      elseif ls.locally_jumpable(1) then
        return cmp.mapping(ls.jump(1), { 'i', 's' })
      else
        return fallback()
      end
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
    event = 'TextChangedI'
  },

  {
    "hrsh7th/cmp-cmdline",
    event = { "TextChangedI", "CmdlineEnter" }
  },

  {
    "hrsh7th/cmp-path",
    event = { "TextChangedI", "CmdlineEnter" }
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    event = "TextChangedI"
  },

  {
    "hrsh7th/cmp-buffer",
    event = { "TextChangedI", "CmdlineEnter" }
  },

  {
    "saadparwaiz1/cmp_luasnip",
    event = "TextChangedI",
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets", },
    event = "TextChangedI",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      local ls = require("luasnip")

      ls.config.set_config {
        history = false,
        updateevents = "TextChanged,TextChangedI"
      }

      -- Defer the loading of custom snippets
      vim.defer_fn(function()
        local here = ModuleResolver.whereami()
        local parent = ModuleResolver.ascend(here, 2)
        local custom = vim.fs.joinpath(parent, "03-postplug/custom-snippets/")

        for ename, _ in vim.fs.dir(custom) do
          local lua_file = vim.fs.joinpath(custom, ename)
          Safe.try(function()
            loadfile(lua_file)()
          end, function(v1, v2)
            PrintDbg("Failed to load custom snippets file: " .. lua_file, LL_ERROR, { v1, v2 })
          end)
        end
      end, 1000)

      Events.fire_event {
        actor = "luasnip",
        event = "configured"
      }
    end,
  },

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
    "PsychedelicShayna/faster-nvim-cmp", -- Fork with faster performance.
    branch = "perf",
    event = "TextChangedI",
    build = "make install_jsregexp",
    dependencies = { "L3MON4D3/LuaSnip" },

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

          view = {
            entries = {
              name = 'custom',
              selection_order = 'top_down',
            },
            docs = {
              auto_open = false,
            },
          },

          performance = {
            -- fetching_timeout = 200,
            max_view_entries = 50,
            async_budget = 100,
            -- throttle = 125,
          },

          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
              -- local icon = icons[vim_item.kind] or vim_item.kind
              -- vim_item.kind = string.format("%s", icon)

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
            { name = "nvim_lsp", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lua", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "luasnip",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "buffer",   option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "path",     option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "null_ls",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "copilot",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
          },

          -- sorting = {
          -- priority_weight = 1,
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
            completion = cmp.config.window.bordered {
              border = 'single',
              scrollbar = true
            },
            documentation = { border = 'single', scrollbar = true,
              max_height = 10,
              max_width = 45,
            }
          },

          mapping = mappings(cmp),
        }

        local cmdline_mappings = {
          ['<A-i>'] = {
            c = function()
              if not cmp.visible() then
                return cmp.mapping(cmp.complete(), { 'i', 's', 'c' })
              else
                return cmp.mapping(cmp.close(), { 'i', 's', 'c' })
              end
            end,
          },
          ['<A-j>'] = {
            c = function()
              if cmp.visible() then
                return cmp.mapping(cmp.select_next_item(), { 'i', 's', 'c' })
              else
                return cmp.mapping(cmp.complete(), { 'i', 's', 'c' })
              end
            end,
          },
          ['<A-k>'] = {
            c = function()
              if cmp.visible() then
                return cmp.mapping(cmp.select_prev_item(), { 'i', 's', 'c' })
              else
                return cmp.mapping(cmp.complete(), { 'i', 's', 'c' })
              end
            end,
          },
          ['<C-n>'] = {
            c = function(fallback)
              if cmp.visible() then cmp.close() end
              fallback()
            end,
          },
          ['<A-h>'] = {
            c = function()
              if cmp.visible() then
                return cmp.mapping(cmp.close(), { 'i', 's', 'c' })
              end
            end
          },
          ['<A-l>'] = {
            c = function(fallback)
              local cmp = require('cmp')
              if cmp.visible() then
                return cmp.mapping(cmp.complete(), { 'i', 's', 'c' })
              end
            end
          }
        }

        cmp.setup.cmdline("/", {
          sources = {
            { name = "buffer", option = { get_bufnrs = cmp_buffer_size_check, performance = { async_budget = 50 } }, lazy = false },
          },
          mapping = cmdline_mappings,
          performance = {
            fetching_timeout = 50,
            async_budget = 50,
            max_view_entries = 10
          }
        })


        cmp.setup.cmdline(":", {
          mapping = cmdline_mappings,
          -- matching = {
          --   disallow_fuzzy_matching = false,
          --   disallow_fullfuzzy_matching = false,
          --   disallow_partial_fuzzy_matching = false,
          --   disallow_partial_matching = false,
          --   disallow_prefix_unmatching = false,
          --   disallow_symbol_nonprefix_matchin = false,
          -- },

          sources = cmp.config.sources({
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!", "Z", "Zl", "Zt" },
                treat_trailing_slash = false
              }
            },
            { name = "buffer", option = { get_bufnrs = cmp_buffer_size_check, performance = { async_budget = 50 } }, lazy = false },
            { name = "path" },
          }),

          performance = {
            fetching_timeout = 50,
            async_budget = 50,
            max_view_entries = 10,
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
