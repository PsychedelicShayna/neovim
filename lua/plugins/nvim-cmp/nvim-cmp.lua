local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

--   פּ ﯟ   some other good icons
-- Find more here: https://www.nerdfonts.com/cheat-sheet
local kind_icons = {
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


cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
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

    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.

    --[[ ["<CR>"] = cmp.mapping.confirm { select = true }, ]]
    ["<C-l>"] = cmp.mapping.confirm({ select = true }),

    -- Used to be responsible for scrolling docs, but conflicts with uppercase
    -- K and J! Something else needs to be found, but for now, disabled.
    --
    -- ["K"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.scroll_docs(-1)
    --   else
    --     fallback()
    --   end
    -- end),
    --
    -- ["J"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.scroll_docs(1)
    --   else
    --     fallback()
    --   end



    --[[ ["<Tab>"] = cmp.mapping( ]]
    --[[   function(fallback) ]]
    --[[     if cmp.visible() and cmp.get_active_entry() then ]]
    --[[       cmp.select_next_item() ]]
    --[[     elseif luasnip.expandable() then ]]
    --[[       luasnip.expand() ]]
    --[[     elseif luasnip.expand_or_jumpable() then ]]
    --[[       luasnip.expand_or_jump() ]]
    --[[     elseif check_backspace() then ]]
    --[[       fallback() ]]
    --[[     else ]]
    --[[       fallback() ]]
    --[[     end ]]
    --[[]]
    --[[   end, { "i", "s" } ]]
    --[[ ), ]]
    --[[]]
    --[[ ["<S-Tab>"] = cmp.mapping( ]]
    --[[   function(fallback) ]]
    --[[     if cmp.visible() then ]]
    --[[       cmp.select_prev_item() ]]
    --[[     elseif luasnip.jumpable(-1) then ]]
    --[[       luasnip.jump(-1) ]]
    --[[     else ]]
    --[[       fallback() ]]
    --[[     end ]]
    --[[   end, { "i", "s" } ]]
    --[[ ) ]]
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },

    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item

      vim_item.menu = ({
        path = "[Path]",
        copilot = "[AI]",
        nvim_lua = "[NVL]",
        nvim_lsp = "[LSP]",
        null_ls = "[NLS]",
        luasnip = "[Snip]",
        spell = "[Spell]",
        buffer = "[Buffer]",
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
    { name = "luasnip" },
    { name = "buffer" },
  },

  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  experimental = {
    ghost_text = true,
    native_menu = false,
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources(
    { { name = "cmp_git" } },
    { { name = "buffer" } }
  )
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = "path" } },
    { { name = "cmdline" } }
  )
})