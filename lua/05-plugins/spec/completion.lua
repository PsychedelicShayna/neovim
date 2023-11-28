local icons = { --| Alternative Icons
  ---------------------------------------|-------------------
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

local function config()
  local cmp = require("cmp")
end

return {
  { "L3MON4D3/LuaSnip",       lazy = true },
  { "hrsh7th/cmp-nvim-lsp",   lazy = true },
  { "hrsh7th/cmp-nvim-lua",   lazy = true },
  { "hrsh7th/cmp-path",       lazy = true },
  -- { "hrsh7th/cmp-buffer",     lazy = true },
  { "hrsh7th/cmp-cmdline",    lazy = true },
  { "zbirenbaum/copilot-cmp", lazy = true, dependencies = { "copilot.lua" } },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      -- "zbirenbaum/copilot-cmp"
    },
    config = function()
      -------------------------------------------------------------------------
      vim.defer_fn(function()
        local import_name = "cmp"
        local nvim_cmp_ok, nvim_cmp = pcall(require, import_name)
        local nvim_cmp = require("cmp")

        if not nvim_cmp_ok then
          PrintDbg(
            "Failed to import plugin \"hrsh7th/nvim-cmp\" under name \"" ..
            import_name .. "\" within its own config() function.", LL_ERROR, { nvim_cmp_ok, nvim_cmp })
          return
        end
        -----------------------------------------------------------------------
        nvim_cmp.setup {
          snippet = {
            expand = function(args)
              local rname_luasnip = "luasnip"
              local luasnip_ok, luasnip = pcall(require, rname_luasnip)

              if luasnip_ok then
                return luasnip.lsp_expand(args.body)
              else
                PrintDbg(
                  "Could not import plugin \"L3MON4D3/LuaSnip\" within config function of plugin \"hrsh7th/nvim-cmp\", under name \"'" ..
                  rname_luasnip .. "\". Consider the plugin being configured as unstable, due to its strange dependency.",
                  LL_WARN, { luasnip_ok, luasnip })
                return nil
                -- vim.notify('Could not find luasnip, needed by nvim-cmp for expansion of snippets and more!')
                -- vim.notify(
                -- 'Even if you do not use snippets, downloading luasnip is greatly recommended when using nvim-cmp!')
              end
            end
          },
          ---- Matching -------------------------------------------------------
          -- matching = {
          --   disallow_fuzzy_matching = false,
          --   disallow_fullfuzzy_matching = false,
          --   disallow_partial_fuzzy_matching = true,
          --   disallow_partial_matching = false,
          --   disallow_prefix_unmatching = false,
          -- },
          ---- Performance ----------------------------------------------------
          performance = {
            debounce         = 150, -- 60
            throttle         = 100, -- 30
            async_budget     = 1,   -- 1
            max_view_entries = 100, -- 200
            fetching_timeout = 50,  -- 500
          },
          ---- Completion -----------------------------------------------------
          -- completion = {
          --   autocomplete = {
          --     nvim_cmp.TriggerEvent.TextChanged,
          --   },
          --   completeopt = 'menu,menuone,noselect',
          --   keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
          --   keyword_length = 1,
          -- },
          ---- Experimental ---------------------------------------------------
          -- experimental = {
          --   ghost_text = false,
          -- },
          ---- View -----------------------------------------------------------
          view = {
            entries = {
              name = 'custom',
              selection_order = 'top_down',
            },
            docs = {
              auto_open = false,
            },
          },
          ---- Mapping --------------------------------------------------------
          mapping = {
            ["<A-k>"] = nvim_cmp.mapping.select_prev_item({ behavior = nvim_cmp.SelectBehavior.Select }),
            ["<A-j>"] = nvim_cmp.mapping.select_next_item({ behavior = nvim_cmp.SelectBehavior.Select }),

            -- Open the completion window, or confirm the selected completion
            -- if the window is already open and a completion is selected.
            ["<A-l>"] = function(fallback)
              if nvim_cmp.visible() then
                return nvim_cmp.confirm()
              elseif not nvim_cmp.visible() then
                return nvim_cmp.complete()
              else
                return fallback()
              end
            end,

            -- Complete by common strings in the buffer.
            ["<A-N>"] = function(fallback)
              return nvim_cmp.complete_common_string()
            end,

            -- Close the completion window.
            ["<A-h>"] = function(fallback)
              if nvim_cmp.visible() then
                return nvim_cmp.close()
              else
                return fallback()
              end
            end,

            -- Open and close documentation window.
            ["<A-H>"] = function(fallback)
              if nvim_cmp.visible_docs() then
                return nvim_cmp.close_docs()
              elseif not nvim_cmp.visible_docs() then
                return nvim_cmp.open_docs()
              else
                return fallback()
              end
            end,

            -- Scroll down the documentation window.
            ["<A-J>"] = function(fallback)
              if nvim_cmp.visible_docs() then
                return nvim_cmp.mapping(nvim_cmp.scroll_docs(1), { "i", "c" })
              else
                return fallback()
              end
            end,

            -- Scroll up the documentation window.
            ["<A-K>"] = function(fallback)
              if nvim_cmp.visible_docs() then
                return nvim_cmp.mapping(nvim_cmp.scroll_docs(-1), { "i", "c" })
              else
                return fallback()
              end
            end,
          },

          ---- Menu Format ----------------------------------------------------
          -- formatting = {
          --   fields = { "kind", "abbr", "menu" },
          --   format = function(entry, vim_item)
          --     local source = ({
          --       path = "P",
          --       copilot = "G",
          --       nvim_lua = "V",
          --       nvim_lsp = "L",
          --       null_ls = "N",
          --       spell = "S",
          --       buffer = "B",
          --       cmdline = "C"
          --     })[entry.source.name]
          --
          --     local icon = icons[vim_item.kind] or vim_item.kind
          --     vim_item.kind = string.format("[%s] %s) %s", source, icon, vim_item.kind)
          --
          --     return vim_item
          --   end,
          -- },
          ---- Default Completion Sources -------------------------------------
          sources = {
            { name = "path",     option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lsp", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "nvim_lua", option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "null_ls",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            { name = "copilot",  option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
            -- { name = "buffer",   option = { get_bufnrs = cmp_buffer_size_check }, lazy = true },
          },

          ---- Confirmation Behavior ------------------------------------------
          -- confirmation = {
          --   default_behavior = nvim_cmp.ConfirmBehavior.Insert,
          --   get_commit_characters = function(commit_characters)
          --     return commit_characters
          --   end,
          -- },

          ---- Window Appearance ----------------------------------------------
          window = {
            completion = nvim_cmp.config.window.bordered {
              border = 'single',
              scrollbar = false
            },
            documentation = {
              border = 'single',
            }
          },
          ---------------------------------------------------------------------
          -- sorting = {
          -- priority_weight = 4,
          -- comparators = {
          --   nvim_cmp.compare.score,
          --   nvim_cmp.compare.kind,
          --   nvim_cmp.compare.order,
          --   nvim_cmp.compare.recently_used,
          --   nvim_cmp.compare.exact,
          --   nvim_cmp.compare.offset,
          --   -- nvim_cmp.compare.scopes,
          --   nvim_cmp.compare.locality,
          --   -- nvim_cmp.compare.sort_text,
          --   nvim_cmp.compare.length,
          -- },
          -- },
        }
        -----------------------------------------------------------------------
        -- nvim_cmp.setup.filetype("gitcommit", {
        --   sources = nvim_cmp.config.sources(
        --     { { name = "cmp_git" } },
        --     { { name = "buffer" } }
        --   )
        -- })
        ---- ------------------------------------------------------------------

        -- nvim_cmp.setup.cmdline({ "/", "?" }, {
        --   mapping = {
        --     ["<A-k>"] = {
        --       c = nvim_cmp.mapping.select_prev_item({ behavior = nvim_cmp.SelectBehavior.Select })
        --     },
        --
        --     ["<A-j>"] = {
        --       c = nvim_cmp.mapping.select_next_item({ behavior = nvim_cmp.SelectBehavior.Select })
        --     },
        --
        --     -- Open the completion window, or confirm the selected completion
        --     -- if the window is already open and a completion is selected.
        --     ["<A-l>"] = {
        --       c = function(fallback)
        --         if nvim_cmp.visible() then
        --           return nvim_cmp.confirm()
        --         elseif not nvim_cmp.visible() then
        --           return nvim_cmp.complete()
        --         else
        --           return fallback()
        --         end
        --       end,
        --     },
        --
        --     -- Close the completion window.
        --     ["<A-h>"] = {
        --       c = function(fallback)
        --         if nvim_cmp.visible() then
        --           return nvim_cmp.close()
        --         else
        --           return fallback()
        --         end
        --       end,
        --     },
        --   },
        --   sources = {
        --     {
        --       name = "buffer",
        --       performance = {
        --         fetching_timeout = 100,
        --         max_view_entries = 50
        --       },
        --       option = { get_bufnrs = cmp_buffer_size_check }
        --     }
        --   }
        -- })

        -- nvim_cmp.setup.cmdline(":", {
        --   mapping = {
        --     ["<A-k>"] = {
        --       c = nvim_cmp.mapping.select_prev_item({ behavior = nvim_cmp.SelectBehavior.Select })
        --     },
        --
        --     ["<A-j>"] = {
        --       c = nvim_cmp.mapping.select_next_item({ behavior = nvim_cmp.SelectBehavior.Select })
        --     },
        --
        --     -- Close the completion window.
        --     ["<A-h>"] = {
        --       c = function(fallback)
        --         if nvim_cmp.visible() then
        --           return nvim_cmp.close()
        --         else
        --           return fallback()
        --         end
        --       end,
        --     },
        --
        --     -- Open the completion window, or confirm the selected completion
        --     -- if the window is already open and a completion is selected.
        --     ["<A-l>"] = {
        --       c = function(fallback)
        --         if nvim_cmp.visible() then
        --           return nvim_cmp.confirm()
        --         elseif not nvim_cmp.visible() then
        --           return nvim_cmp.complete()
        --         else
        --           return fallback()
        --         end
        --       end,
        --     },
        --   },
        --   performance = {
        --     fetching_timeout = 100,
        --     max_view_entries = 50
        --   },
        --   sources = {
        --     { name = "path" },
        --     {
        --       name = "cmdline",
        --       option = { ignore_cmds = { "/", "?", "s" } },
        --       max_item_count = 50
        --     }
        --   }
        -- })

        Events.fire_event {
          actor = "nvim-cmp",
          event = "configured"
        }
      end, 500)
      -------------------------------------------------------------------------
    end,
  },


  --
  -- {
  --   "hrsh7th/cmp-buffer",
  --   keys = { "/", "?" },
  --   lazy = true,
  --   config = function()
  --     local cmp = require("cmp")
  --
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         {
  --           name = "buffer",
  --           option = { get_bufnrs = cmp_buffer_size_check }
  --         }
  --       }
  --     })
  --   end
  -- },
  --
  -- {
  --   "hrsh7th/cmp-cmdline",
  --   dependencies = { "nvim-cmp", "cmp-path", }, -- "cmp-buffer" },
  --   keys = ":",
  --   lazy = true,
  --   config = function()
  --     local cmp = require("cmp")
  --
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       performance = {
  --         fetching_timeout = 100,
  --         max_view_entries = 10
  --       },
  --       sources = {
  --         { name = "path" },
  --         {
  --           name = "cmdline",
  --           option = {
  --             ignore_cmds = { "/", "?", "s" }, --  { "term", "terminal", "Man", " !" }
  --           },
  --           max_item_count = 10
  --         },
  --         {
  --           name = "buffer",
  --           option = {
  --             get_bufnrs = cmp_buffer_size_check
  --           },
  --           max_item_count = 20
  --         },
  --       }
  --     })
  --   end,
  -- },

}
