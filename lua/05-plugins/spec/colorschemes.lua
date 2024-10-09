local colorschemes = {
  { "EdenEast/nightfox.nvim",     lazy = true },
  { "FrenzyExists/aquarium-vim",  lazy = true },
  { "LunarVim/Colorschemes",      lazy = true },
  { "LunarVim/horizon.nvim",      lazy = true },
  { "LunarVim/onedarker.nvim",    lazy = true },
  { "LunarVim/synthwave84.nvim",  lazy = true },
  { "Mofiqul/dracula.nvim",       lazy = true },
  { "RRethy/nvim-base16",         lazy = true },
  { "Shatur/neovim-ayu",          lazy = true },
  { "andersevenrud/nordic.nvim",  lazy = true },
  { "bluz71/vim-nightfly-colors", lazy = true },
  { "catppuccin/nvim",            lazy = true },
  { "doki-theme/doki-theme-vim",  lazy = true },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      -- vim.defer_fn(function()
      require("rose-pine").setup {
        highlight_groups = {
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
        },

        dark_variant = 'main',
        bold_vert_split = false,
        -- dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,

        variant = "moon",
        disable = {
          background = false,
          cursor_coloring = false,
          terminal_colors = false,
          eob_lines = false,
        },
      }
      -- end, 1)

      vim.cmd("colorscheme rose-pine")
    end
  },
  { "fenetikm/falcon",                  lazy = true },
  { "folke/tokyonight.nvim",            lazy = true },
  { "jdsimcoe/hyper.vim",               lazy = true },
  { "kvrohit/rasmus.nvim",              lazy = true },
  { "lalitmee/cobalt2.nvim",            lazy = true },
  { "lunarvim/darkplus.nvim",           lazy = true },
  { "numToStr/Sakura.nvim",             lazy = true },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },
  { "projekt0n/github-nvim-theme",      lazy = true },
  { "rebelot/kanagawa.nvim",            lazy = true },
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    config = function()
        -- -- Enables some form of caching.
        vim.g.gruvbox_material_better_performance = 0
        --
        -- -- Enable italics keywords.
        -- vim.g.gruvbox_material_enable_italic = 2
        --
        -- -- Enable italic comments.
        vim.g.gruvbox_material_disable_italic_comment = 0
        --
        -- Transparency: 0 = None, 1 = Some, 2 = More
        vim.g.gruvbox_material_transparent_background = 2
        --
        -- -- Palette to use, can be soft, medium, or hard.
        -- vim.g.gruvbox_material_background = 'medium'
        -- vim.g.gruvbox_material_foreground = 'medium'
        --
        -- -- Can be low or high. Affects line numbers, indent lines, etc.
        vim.g.gruvbox_material_ui_contrast = 'high'
        --
        -- -- How to make floating windows stand out; can be 'bright' or 'dim'
        -- vim.g.gruvbox_material_float_style = 'dim'

        vim.cmd("colorscheme gruvbox-material")
    end
  },
  { "srcery-colors/srcery-vim", lazy = true },
  { "titanzero/zephyrium",      lazy = true },
  { "whatyouhide/vim-gotham",   lazy = true },
  { "yazeed1s/minimal.nvim",    lazy = true },
  { "neanias/everforest-nvim",  lazy = true },
}

ColorschemeNames = vim.tbl_map(function(colorscheme)
  if not colorscheme or type(colorscheme[1]) ~= "string" then
    return "Unknown"
  end

  local repo_uri = colorscheme[1]

  local repo_name = string.sub(repo_uri,
    (string.find(repo_uri, "/", 1, true) + 1) or 1
  )

  return repo_name
end, colorschemes)

table.insert(ColorschemeNames, "For base16 themes, add base16- before the theme, e.g. base16-solarized-dark")

vim.api.nvim_create_user_command("ColorschemeList", function()
  local buf_before = vim.api.nvim_get_current_buf()
  vim.api.nvim_command("vnew Colorscheme List")
  local buf_after = vim.api.nvim_get_current_buf()

  if buf_before == buf_after then
    vim.notify("The current buffer is the same as the previous buffer, aborting.")
    return
  end

  vim.api.nvim_buf_set_lines(buf_after, 0, -1, false, ColorschemeNames)
end, {})

return colorschemes
