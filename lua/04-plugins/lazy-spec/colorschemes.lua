local colorschemes = {
  { "EdenEast/nightfox.nvim",    lazy = true },
  { "FrenzyExists/aquarium-vim", lazy = true },
  { "LunarVim/Colorschemes",     lazy = true },
  { "LunarVim/horizon.nvim",     lazy = true },
  { "LunarVim/onedarker.nvim",   lazy = true },
  { "LunarVim/synthwave84.nvim", lazy = true },
  { "Mofiqul/dracula.nvim",      lazy = true },
  { "RRethy/nvim-base16",        lazy = true },
  {
    "p00f/alabaster.nvim",
    lazy = true,
    config = function()
      vim.cmd("color alabaster")
    end
  },
  { "Shatur/neovim-ayu",          lazy = true },
  { "andersevenrud/nordic.nvim",  lazy = true },
  { "bluz71/vim-nightfly-colors", lazy = true },
  {
    "catppuccin/nvim",
    lazy = true,
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
      }

      require("catppuccin").setup {
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin"
      }

      vim.cmd('color catppuccin-mocha')
    end
  },
  { "doki-theme/doki-theme-vim", lazy = true },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    config = function()
      require("cyberdream").setup({
        -- Enable transparent background
        transparent = true,

        -- Enable italics comments
        italic_comments = true,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = false,

        -- Modern borderless telescope theme - also applies to fzf-lua
        borderless_telescope = true,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
        cache = false,

        theme = {
          variant = "default", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
          saturation = 1,      -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)
          highlights = {
            -- Highlight groups to override, adding new groups is also possible
            -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

            -- Example:
            -- Comment = { fg = "#696969", bg = "NONE", italic = true },

            -- Complete list can be found in `lua/cyberdream/theme.lua`
          },

          -- Override a highlight group entirely using the color palette
          -- overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
          --   -- Example:
          --   return {
          --     Comment = { fg = colors.green, bg = "NONE", italic = true },
          --     ["@property"] = { fg = colors.magenta, bold = true },
          --   }
          -- end,

          -- Override a color entirely
          -- colors = {
          --   -- For a list of colors see `lua/cyberdream/colours.lua`
          --   -- Example:
          --   bg = "#000000",
          --   green = "#00ff00",
          --   magenta = "#ff00ff",
          -- },
        },

        -- Disable or enable colorscheme extensions
        extensions = {
          telescope = true,
          notify = true,
          mini = true,
        },
      })

      -- vim.cmd("color cyberdream")
    end
  },
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
        dim_nc_background = false,
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

      -- vim.cmd("colorscheme rose-pine")
    end
  },
  { "fenetikm/falcon",           lazy = false },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
      require('tokyonight').setup {
        style = "storm",        -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
        light_style = "day",    -- The theme is used when the background is set to light
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          -- functions = {},
          -- variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark",  -- style for sidebars, see below
          floats = "dark",    -- style for floating windows
        },
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        dim_inactive = false, -- dims inactive windows
        -- lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

        --   --- You can override specific color groups to use other groups or a hex color
        --   --- function will be called with a ColorScheme table
        --   ---@param colors ColorScheme
        --   on_colors = function(colors) end,
        --
        --   --- You can override specific highlights to use other groups or a hex color
        --   --- function will be called with a Highlights and ColorScheme table
        --   ---@param highlights tokyonight.Highlights
        --   ---@param colors ColorScheme
        --   on_highlights = function(highlights, colors) end,

        cache = true, -- When set to true, the theme will be cached for better performance

        ---@type table<string, boolean|{enabled:boolean}>
        plugins = {
          -- enable all plugins when not using lazy.nvim
          -- set to false to manually enable/disable plugins
          -- all = package.loaded.lazy == nil,
          -- uses your plugin manager to automatically enable needed plugins
          -- currently only lazy.nvim is supported
          auto = true,
          -- add any plugins here that you want to enable
          -- for all possible plugins, see:
          --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
          -- telescope = true,
        },
      }
      vim.cmd('color tokyonight-storm')
    end

  },
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
      vim.g.gruvbox_material_better_performance = 1
      --
      -- -- Enable italics keywords.
      vim.g.gruvbox_material_enable_italic = 2
      --
      -- -- Enable italic comments.
      -- vim.g.gruvbox_material_disable_italic_comment = 0
      --
      -- Transparency: 0 = None, 1 = Some, 2 = More

      -- vim.g.gruvbox_material_transparent_background = 0

      -- if UsrLib.proclib.pgrep("picom", { exact = true }) ~= nil then
      --     vim.g.gruvbox_material_transparent_background = 1
      -- end

      -- -- Palette to use, can be soft, medium, or hard.
      -- vim.g.gruvbox_material_background = 'medium'
      -- vim.g.gruvbox_material_foreground = 'medium'
      --
      -- -- Can be low or high. Affects line numbers, indent lines, etc.
      -- vim.g.gruvbox_material_ui_contrast = 'high'
      --
      -- -- How to make floating windows stand out; can be 'bright' or 'dim'
      -- vim.g.gruvbox_material_float_style = 'bright'

      -- vim.cmd("colorscheme gruvbox-material")

      local adapt = false

      if adapt then
        vim.defer_fn(function()
          local h = io.popen("pgrep --exact picom", "r")

          if h then
            local r = h:read()
            h:close()

            if r ~= nil then
              vim.g.gruvbox_material_transparent_background = 1
              vim.cmd("colorscheme gruvbox-material")
            end
          end
        end, 1)
      end

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
