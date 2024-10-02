-- s = {
--   "<cmd>ClangdSwitchSourceHeader<cr>",
--   "Switch Source/Header Buffers"
-- },
-- p = {
--   "<cmd>ProjectRootToggle<cr>",
--   "Toggle Project AutoRoot"

-- :WK_OLD_MAPPING
-- {
--   f = { name = "Find" },
--   -- Buffer Operations
--   b = {
--     name = "Buffer...",
--     d = { "<cmd>Bdelete<cr>", "Delete Buffer (Force)" },
--   },
--   w = {
--     name = "Window...",
--
--     h = { "<cmd>split<cr>", "Split Window Horizontally" },
--     v = { "<cmd>vsplit<cr>", "Split Window Vertically" },
--     c = { "<cmd>close<cr>", "Close Window" },
--     n = { "<cmd>new<cr>", "New Window" },
--   },
--   l = {
--     name = "LSP",
--
--     F = {
--       "<cmd>:ToggleAutoFormat<cr>",
--       "Toggle AutoFormat"
--     },
--
--     H = {
--       "<cmd>lua require(\"cmp\").mapping.complete()<cr>",
--       "Complete Here"
--     },
--   },
--   c = {
--     name = "Neovim Control...",
--     m = { "<cmd>Mason<cr>", "Mason" },
--     l = { "<cmd>Lazy<cr>", "Lazy" },
--     c = { "<cmd>e ~/.config/nvim<cr>", "Configuration" }
--   },
--   d = {
--     name = "Diagnostics...",
--     j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next", },
--     k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous", },
--     l = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Location List", },
--   },
-- }

local default_mappings = {
  { "<space>b",  group = "[Buffer]" },
  { "<space>bd", "<cmd>Bdelete<cr>",                               desc = "Delete Buffer (Force)" },
  { "<space>c",  group = "[NeoVim Options]" },
  { "<space>cv", "<cmd>e ~/.config/nvim<cr>",                      desc = "Configure Neovim" },
  { "<space>cs", "<cmd>TSInstallInfo<cr>",                             desc = "Syntax Parsers (Treesitter)" },
  { "<space>cp", "<cmd>Lazy<cr>",                                  desc = "Plugin Manager (Lazy)" },
  { "<space>cl", "<cmd>Mason<cr>",                                 desc = "LSP Manager (Mason)" },
  { "<space>d",  group = "[Debugging]" },
  { "<space>dj", "<cmd>lua vim.diagnostic.goto_next()<cr>",        desc = "Next Diagnostic" },
  { "<space>dk", "<cmd>lua vim.diagnostic.goto_prev()<cr>",        desc = "Previous Diagnostic" },
  { "<space>f",  group = "[Find]" },
  { "<space>l",  group = "[LSP]" },
  { "<space>ll", "<cmd>lua vim.diagnostic.setloclist()<cr>",       desc = "Location List" },
  { "<space>lF", "<cmd>:ToggleAutoFormat<cr>",                     desc = "Toggle AutoFormat" },
  { "<space>lH", '<cmd>lua require("cmp").mapping.complete()<cr>', desc = "Complete Here" },
  { "<space>w",  group = "[Window]" },
  { "<space>wc", "<cmd>close<cr>",                                 desc = "Close Window" },
  { "<space>wh", "<cmd>split<cr>",                                 desc = "Split Window Horizontally" },
  { "<space>wn", "<cmd>new<cr>",                                   desc = "New Window" },
  { "<space>wv", "<cmd>vsplit<cr>",                                desc = "Split Window Vertically" },
}


return {
  "folke/which-key.nvim",
  -- event = "UIEnter",
  -- key = "*",
  -- keys = { "<leader>", "z", "=" },

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 200
  end,


  config = function()
    local ok, wk = pcall(require, "which-key")

    if not ok then
      vim.notify("Could not import which-key within its own config function!", vim.log.levels.WARN)
      vim.notify("Skipping which-key config; which-key will not be available.", vim.log.levels.WARN)

      Events.fire_event { actor = "which-key", event = "failed" }
      return
    end

    wk.setup {
      preset = 'helix',
      win = {

        title = true,
        title_pos = "center",
        border = "double",
        padding = { 1, 2 }
      },
      plugins = {
        spelling = { enabled = true, },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },

      replace = {
        desc = {
          function(key)
            return key
          end,
          -- { "<Space>", "SPC" },
        },
        -- desc = {
        --   { "<Plug>%(?(.*)%)?", "%1" },
        --   { "^%+", "" },
        --   { "<[cC]md>", "" },
        --   { "<[cC][rR]>", "" },
        --   { "<[sS]ilent>", "" },
        --   { "^lua%s+", "" },
        --   { "^call%s+", "" },
        --   { "^:%s*", "" },
        -- },
      },

      icons = {
        mappings = false,
        group = ''
      }
    }

    wk.add(default_mappings)

    Events.fire_event { actor = "which-key", event = "configured", }
  end
}
