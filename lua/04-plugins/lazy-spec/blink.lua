-- local function fn_keymap_select_prev(cmp)
--   if cmp.snippet_active() then vim.snippet.stop() end
--   cmp.select_prev({ on_ghost_text = true })
-- end
--
-- local function fn_keymap_select_next(cmp)
--   if cmp.snippet_active() then vim.snippet.stop() end
--   cmp.select_next({ on_ghost_text = true })
-- end


-- If ghost text is currently visible, cycle through it. If it's not then
-- force the menu open to have something to cycle through. If a snippet is
-- active, then try to stop it. The string argument determines the direction.
-- Note: this returns a function
---@param direction string `"prev"` or `"next"`
-- local function fn_ghost_cycle(direction)
--   return function(ctx)
--     if not ctx.is_menu_visible() then
--       ctx.show_and_insert_or_accept_single()
--       return true
--     end
--
--     if ctx.snippet_active() then vim.snippet.stop() end
--     local ok, gt = pcall(require, "blink.cmp.completion.windows.ghost_text")
--
--     if not ok then
--       vim.notify("Cannot import modulle blink.cmp.completion.windows.ghost_text", vim.log.levels.ERROR)
--       return false
--     end
--
--     if gt.is_open() or ctx.is_ghost_text_visible() then
--       ctx[direction] { on_ghost_text = true }
--       return true
--     end
--
--     return false
--   end
-- end

-- local function partial(f, a1, a2)
--   if a1 ~= nil then
--     return function(a)
--       f(a1, a)
--     end
--   elseif a2 ~= nil then
--     return function(a)
--       f(a, a2)
--     end
--   end
-- end

-- local function fn_keymap_alternate_down(cmp)
--   if cmp.is_menu_visible() and cmp.is_documentation_visible() then
--     cmp.scroll_documentation_down()
--     return
--   end
--
--   local ok, copilot = pcall(require, 'copilot.suggestion')
--   local gt = require("blink.cmp.completion.windows.ghost_text")
--
--   if ok then
--     vim.defer_fn(function()
--       if copilot.is_visible() then
--         if gt.is_open() or cmp.is_ghost_text_visible() then
--           gt.clear_preview()
--         end
--         -- vim.notify("is indeed visible")
--       end
--     end, 1200)
--
--     if copilot.is_visible() then
--       gt.clear_preview()
--     end
--   end
-- end
--
-- local function fn_keymap_alternate_up(cmp)
--   local ok, copilot = pcall(require, 'copilot.suggestion')
--   local gt = require("blink.cmp.completion.windows.ghost_text")
--   if ok then
--     vim.defer_fn(function()
--       if copilot.is_visible() then
--         if gt.is_open() or cmp.is_ghost_text_visible() then
--           gt.clear_preview()
--         end
--         -- vim.notify("is indeed visible")
--       end
--     end, 1200)
--     if copilot.is_visible() then
--       gt.clear_preview()
--       vim.notify("is indeed visible")
--     end
--   end
-- end

-- local function fn_keymap_open_menu(cmp)
--   local ok, copilot = pcall(require, 'copilot.suggestion')
--   local gt = require("blink.cmp.completion.windows.ghost_text")
--
--   if ok then
--     if copilot.is_visible() then
--       if gt.is_open() or cmp.is_ghost_text_visible() then
--         gt.clear_preview()
--       end
--     end
--   end
--
--   if vim.snippet.active() then
--     vim.snippet.stop()
--     -- return
--   end
--
--   if not cmp.is_menu_visible() then
--     cmp.show()
--   elseif cmp.is_menu_visible() and not cmp.is_documentation_visible() then
--     cmp.show_documentation()
--   else
--     cmp.hide()
--   end
-- end

-- local function fn_keymap_show_docs(cmp)
--   if cmp.is_documentation_visible() then
--     cmp.hide_documentation()
--   elseif cmp.is_signature_visible() then
--     cmp.hide_signature()
--   elseif not cmp.is_menu_visible() then
--     cmp.show_signature()
--   else
--     cmp.show_documentation()
--   end
-- end

-- Hybrid scrolling function that handles both ghost text when visible and
-- scrollig the docuentation when the menu is visible.
---@param direction_docs string `"up"` or `"down"`
---@param direction_ghost string `"prev"` or `"next"`
local function fn_c_hybrid_special_cycle(direction_docs, direction_ghost)
  return function(ctx)
    if ctx.is_menu_visible() then
      local perform_scroll = function()
        local fn = ctx['scroll_documentation_' .. direction_docs]

        if not fn then
          vim.notify("Invalid direction for fn_c_up_down_documentation: " ..
            direction_docs, vim.log.levels.ERROR)
          return false
        end

        fn()
        return true
      end

      -- If the documentation isn't visible, then show it first, and defer
      -- the scrolling action since the menu might take a moment to render.
      if not ctx.is_documentation_visible() then
        ctx.show_documentation()
        vim.defer_fn(function() perform_scroll() end, 100)
        return true
      end

      -- Perform the scroll action immediately if the above didn't trigger.
      return perform_scroll()
    elseif ctx.is_ghost_text_visible() then
      local fn = ctx['select_' .. direction_ghost]

      if not fn then
        vim.notify("Invalid direction for fn_c_hybrid_special_cycle: " ..
          direction_ghost, vim.log.levels.ERROR)
        return false
      end

      fn { on_ghost_text = true }
      return true
    end
  end
end


-- Does whatever it needs to scroll the documentation of the completion menu.
-- If the menu isn't open, it opens it. If the documedntation isn't open, it
-- opens it. It then scrolls the documentation in the direction.
---@param direction string `"up"` or `"down"`
local function fn_c_arrow_documentation(direction)
  return function(ctx)
    if ctx.is_menu_visible() and ctx.is_documentation_visible() then
      local name = "scroll_documentation_" .. direction
      local fn = ctx[name]
      if not fn then
        vim.notify("Invalid direction for fn_c_up_down_documentation: " .. direction, vim.log.levels.ERROR)
        return false
      end

      fn()
      return true
    elseif ctx.is_menu_visible() and not ctx.is_documentation_visible() then
      ctx.show_documentation()
    else
      ctx.show()
    end
    return true
  end
end
-- This is a custom cycler that previews/inserts the item at index
-- 1 that is preselected; normally there is no way to not insert
-- that without also turning on auto_insert, but then you cannot
-- just type what you want while seeing the completions. This way
-- I can continue typing, and when I actually want to insert the
-- preselected item, or any other items below it by cycling, I can
-- just do that wtihout skipping over the first and backtracking.
---@param direction string `"select_prev"` or `"select_next"`
local function fn_tab_insert_preselection(direction)
  return function(ctx)
    local list = require('blink.cmp.completion.list')
    local item = list.get_selected_item()
    local length = #list.items
    local item_idx = list.get_item_idx_in_list(item)
    local item_pre = list.get_selection_mode(ctx).preselect

    local target_idx = direction == "select_prev" and length or 1

    if item_pre and item_idx == target_idx and list.preview_undo == nil then
      list.apply_preview(item)
    else
      list.undo_preview()
      local fn_select = direction == "select_prev" and list.select_prev or list.select_next
      fn_select { auto_insert = true }
    end

    return true
  end
end

---@param direction string `"next"` or `"prev"`
---@param method string `"insert"` or `"select"`
local function fn_cycle_if_open(method, direction)
  return function(ctx)
    if not ctx.is_menu_visible() then
      return false
    end

    local fn = ctx[method .. "_" .. direction]

    if not fn then
      vim.notify("Invalid method or direction for fn_cycle_if_open: " .. method .. " " .. direction,
        vim.log.levels.ERROR)
      return false
    end

    fn()
    return true
  end
end



---@module "lazy"
---@type LazySpec
return {
  'saghen/blink.cmp',
  priority = 1000,
  -- optional: provides snippets for the snippet sourcesnac
  dependencies = {
    { 'rafamadriz/friendly-snippets',    priority = 999, lazy = false },
    { 'giuxtaposition/blink-cmp-copilot' },
    { "mikavilpas/blink-ripgrep.nvim",   version = "*",  lazy = false, priority = 999 }
  },

  -- use a release tag to download pre-built binaries
  -- version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  config = function()
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    local blink = require('blink.cmp')

    blink.setup {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide meneuuu
      -- C-k: Toggle signature help (if signature.enabled = true)
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        -- preset = 'default', 'super-tab', 'enter', 'none'
        preset        = 'none',
        -- Scrolling methods for  documentation and for the completion list.
        ["<C-Up>"]    = { fn_c_hybrid_special_cycle('up', 'prev') },
        ["<C-Down>"]  = { fn_c_hybrid_special_cycle('down', 'next') },
        -- ['<Tab>']     = { fn_tab_insert_preselection('next') },
        -- ['<S-Tab>']   = { 'insert_prev' },
        ['<Down>']    = { fn_cycle_if_open('select', 'next'), 'fallback' },
        ['<Up>']      = { fn_cycle_if_open('select', 'prev'), 'fallback' },
        -- Methods of accepting completion with different bindings.
        ["<S-Up>"]    = { "accept" },
        ["<S-Down>"]  = { "show", "hide" },
        ['<C-Enter>'] = { 'accept', 'fallback' },
        ['<A-l>']     = { 'accept', 'fallback' }, -- muscle memory
        -- Show menu manually
        ['<A-i>']     = { 'show', 'fallback' },   -- muscle memory
        -- Neovim default keys
        ['<C-y>']     = { 'select_and_accept', 'fallback' },
        ['<C-e>']     = { 'cancel', 'show', 'fallback' },
        -- Methods for navigating snippets



        -- ["<C-Up>"] = { fn_c_arrow_documentation('up') },
        -- ["<C-Down>"] = { fn_c_arrow_documentation('down') },
        -- ["<S-Up>"] = { "accept", "fallback" },
        -- ["<C-Space>"] = { "show_and_insert_or_accept_single", "fallback" },
        --
        -- ["<S-Left>"] = { fn_ghost_cycle('select_next'), "select_next", "fallback" },
        -- ["<S-Right>"] = { fn_ghost_cycle('select_next'), "select_prev", "fallback" },
        --
        --
        -- ["<A-e>"] = { "scroll_documentation_down", "fallback" },
        -- ["<A-y>"] = { "scroll_documentation_up", "fallback" },
        --
        -- ["<Tab>"] = { "snippet_backward", "fallback" },
        --
        -- ["<A-J>"] = { fn_keymap_alternate_down },
        -- ["<A-K>"] = { fn_keymap_alternate_up },
        -- ["<A-H>"] = { fn_keymap_show_docs },
        -- ["<A-i>"] = { fn_keymap_open_menu },
        --
        -- ['<C-Enter>'] = { 'accept' },
        --
        -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
        -- ['<C-e>'] = { 'cancel', 'fallback' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },

      signature = {
        enabled = false,
        window = {
          border = "single",
          -- direction_priority = { "s", "n" }
        }
      },

      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'ripgrep', 'copilot' },
        providers = {
          lsp = {
            name = "LSP",
            enabled = true,
            async = true, -- default: false
            should_show_items = true,
            module = 'blink.cmp.sources.lsp',
            -- You may enable the buffer source, when LSP is available, by setting this to `{}`
            fallbacks = { 'buffer' },
            -- You may want to set the score_offset of the buffer source to a lower value, such as -5 in this case
            score_offset = 0,
            timeout_ms = 1000, -- ms
            max_items = nil,
            min_keyword_length = 0,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 10,
            async = true
          },
          path = {
            module = "blink.cmp.sources.path",
            score_offset = 3,
            fallbacks = {},
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              show_hidden_files_by_default = true,
              max_entries = 10000,
            }
          },
          lazydev = {
            name = "lazydev",
            module = "lazydev.integrations.blink",
            score_offset = 4,
          },
          snippets = {
            module = 'blink.cmp.sources.snippets',
            score_offset = 0, -- receives a -3 from top level snippets.score_offset
          },
          cmdline = {
            module = 'blink.cmp.sources.cmdline',
            score_offset = 3
          },
          buffer = {
            module = 'blink.cmp.sources.buffer',
            score_offset = -5,
            opts = {
              -- default to all visible buffers
              get_bufnrs = function()
                return vim
                    .iter(vim.api.nvim_list_wins())
                    :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                    :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                    :totable()
              end,
              -- buffers when searching with `/` or `?`
              get_search_bufnrs = function()
                return {

                  vim
                      .iter(vim.api.nvim_list_wins())
                      :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                      :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                      :totable()

                  -- Originally: vim.api.nvim_get_current_buf()
                }
              end,
              -- Maximum total number of characters (in an individual buffer) for which buffer completion runs synchronously. Above this, asynchronous processing is used.
              max_sync_buffer_size = 50000,
              -- Maximum total number of characters (in an individual buffer) for which buffer completion runs asynchronously. Above this, the buffer will be skipped.
              max_async_buffer_size = 200000,
              -- Maximum text size across all buffers (default: 500KB)
              max_total_buffer_size = 500000,
              -- Order in which buffers are retained for completion, up to the max total size limit (see above)
              retention_order = { 'focused', 'recency', 'visible', 'largest' },
              -- Cache words for each buffer which increases memory usage but drastically reduces cpu usage. Memory usage depends on the size of the buffers from `get_bufnrs`. For 100k items, it will use ~20MBs of memory. Invalidated and refreshed whenever the buffer content is modified.
              use_cache = true,
              -- Whether to enable buffer source in substitute (:s), global (:g) and grep commands (:grep, :vimgrep, etc.).
              -- Note: Enabling this option will temporarily disable Neovim's 'inccommand' feature
              -- while editing Ex commands, due to a known redraw issue (see neovim/neovim#9783).
              -- This means you will lose live substitution previews when using :s, :smagic, or :snomagic
              -- while buffer completions are active.
              enable_in_ex_commands = true,
            }
          },
          ripgrep = {
            name = "ripgrep",
            module = "blink-ripgrep",
            score_offset = -3,
            ---@module "blink-ripgrep"
            ---@type blink-ripgrep.Options
            opts = {
              prefix_min_len = 4,
              project_root_marker = ".git",
              fallback_to_regex_highlighting = true,

              toggles = {
                on_off = "<leader>ccg",
                debug = nil,
              },

              backend = {
                use = "ripgrep",
                customize_icon_highlight = true,
                ripgrep = {
                  context_size = 5,
                  max_filesize = "100K",
                  project_root_fallback = true,
                  search_casing = "--ignore-case",
                  additional_rg_options = { "--max-depth=1" },
                  ignore_paths = {},
                  additional_paths = {},
                },
              },
              gitgrep = {
                additional_gitgrep_options = {}
              },
              debug = false,
            }
          }
        },
      },

      completion = {
        documentation = {
          auto_show = true,
          window = {
            border = "single",
            -- direction_priority = { "n", "s" }
          }
        },

        trigger = {
          show_in_snippet = true,
        },

        list = {
          selection = {
            preselect = true,
            auto_insert = false,
            -- auto_insert = function()
            -- if vim.b.copilot_suggestion_auto_trigger then
            --   return true
            -- end

            --   local ok, copilot = pcall(require, 'copilot.suggestion')
            --
            --   if ok and copilot.is_visible() then
            --     return true
            --   end
            --
            --   return false
            -- end,
          },
        },

        menu = {
          -- Don't automatically show the completion menu
          auto_show = false,
          direction_priority = { 's', 'n' },
          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          }
        },

        keyword = {
          -- 'prefix' will fuzzy match on the text before the cursor
          -- 'full' will fuzzy match on the text before _and_ after the cursor
          -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
          range = 'prefix',
        },


        ghost_text = {
          enabled = true
          -- if vim.b.copilot_suggestion_auto_trigger then
          --   return false
          -- end

          -- local ok, copilot = pcall(require, 'copilot.suggestion')

          -- if ok then
          -- function check()
          --   local cmp = require("blink-cmp")
          --   local gt = require("blink.cmp.completion.windows.ghost_text")
          --
          --   if copilot.is_visible() then
          --     if cmp.is_ghost_text_visible() or gt.is_open() then
          --       gt.clear_preview()
          --     end
          --   end
          --
          --   vim.defer_fn(check, 1000)
          -- end
          --
          -- vim.defer_fn(check, 1000)
          --
          -- if copilot.is_visible() then
          --   return false
          -- end
          -- end

          --   return true
          -- end
        }

      },

      cmdline = {
        enabled = true,
        -- sources = { 'buffer', 'cmdline' },
        completion = {
          list = { selection = { preselect = true, auto_insert = true }, },
          menu = {
            -- height = 10,
            auto_show = function(ctx)
              if true then return true end

              -- short circuit for now
              -- Later on I want to make this a bit more specific, so that
              -- it depends on the source of the selection more than just
              -- where it was invoked. I don't want path completion unless
              -- a command has already been typed AND it does not start with !
              -- and I also do not want path completion to show up without me
              -- providing a prefix ./ in the case that

              local cmdtype = vim.fn.getcmdtype()
              local cmdline = vim.fn.getcmdline()
              local cmptype = vim.fn.getcmdcompltype()

              if vim.list_contains({ "shellcmd", "option", "lua", "help" }, cmptype)
              then
                return true
              end

              ---@type string
              local fullstr = cmdtype .. cmdline
              ---@type integer
              local cursor_pos = vim.fn.getcmdpos()
              -- this will always be non-zero because cmdtype is minimum #1
              ---@type string
              local prevchar = fullstr:sub(cursor_pos, cursor_pos)

              if cmptype == 'file' then
                if prevchar:match("[~/\\.]") then
                  return true
                end
              end

              return false
            end
          },
          ghost_text = { enabled = true },
        },


        -- I do also want to customize the window to be quite small when the
        -- menus hows up automatically, unless I explicitly expand it with
        -- tab or if I somehow interact with it another way. I don't want it
        -- to take much space while I'm typing the command, but when I actually
        -- want to select something from the menu I just can.k
        keymap = {
          preset        = 'cmdline',
          -- Scrolling methods for  documentation and for the completion list.
          ["<C-Up>"]    = { fn_c_arrow_documentation('up') },
          ["<C-Down>"]  = { fn_c_arrow_documentation('down') },
          ['<Tab>']     = { fn_tab_insert_preselection('select_next'), 'fallback' },
          ['<S-Tab>']   = { 'insert_prev', 'fallback' },
          ['<Down>']    = { 'select_next', 'fallback' },
          ['<Up>']      = { 'select_prev', 'fallback' },
          -- Methods of accepting completion with different bindings.
          ["<S-Up>"]    = { "accept", "fallback" },
          ['<C-Enter>'] = { 'accept', 'fallback' },
          ['<A-l>']     = { 'accept', 'fallback' }, -- muscle memory
          -- Neovim default keys
          ['<C-y>']     = { 'select_and_accept', 'fallback' },
          ['<C-e>']     = { 'cancel', 'fallback' },

          -- These keys should do the default vim behavior of moving the cursor
          -- left and right in the command line, even when the menu is open,
          -- because that is very useful and intuitive when editing the command
          -- line. I don't want to have to hold down alt or something to do
          -- that, and I also don't want it to interfere with the completion
          -- menu navigation when the menu is open, so it should only trigger
          -- when the menu is not visible. Not sure if fallback with a cmdline
          -- preset is enough. How would I even 'trigger normal behavir' if I
          -- were to make a function for this? vim.api.nvim_feedkeys with the right keys and 'n' for normal mode? I
          --
          ['<Left>']    = { function(ctx)
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<Left>", true, false, true), 'n', false)
          end, 'fallback' },

          ['<Right>']   = { function(ctx)
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<Right>", true, false, true), 'n', false)
          end, 'fallback' }
        },
      },


      -- (Default) Only show the documentation popup when manually triggered

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`


      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        max_typos = function(keyword) return math.floor(#keyword / 2) end,
      }
    }
  end,

  opts_extend = { "sources.default" }
}
