-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--                   Packer Install, Setup & Nicities
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }

  print "Installing packer, close and reopen NeoViM..."
  vim.cmd [[packadd packer.nvim]]
end

-- Import packer using a protected call, so that in case this is the first time
-- running packer, and ViM hasn't reloaded yet, ViM doesn't outright crash.
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print "Could not import packer, you might need to restart NeoViM if you've just installed packer."
  return
end

-- The packer init configuration.
packer.init {
  max_jobs = 5,
  display = {
    -- Use a popup window for the packer GUI.
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
  profile = {
    enable = true,
    threshold = nil
  },
}

-- AutoCommand that reloads NeoViM when you update this init.lua file, such as
-- when adding or removing a plugin, ensuring that any changes to the file are
-- immediately reflected in NeoViM.
-- vim.cmd [[
--   augroup packer_user_config
--      autocmd!
--      autocmd BufWritePost plugins.lua source <afile> | PackerSync
--    augroup end
-- ]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--                          Packer Plugin List
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return packer.startup(function(use)
  -- Have packer manage itself.
  use {
    "wbthomason/packer.nvim",
    config = function()
      require "plugins.impatient"
    end
  }

  -- Profile startup time.
  use "dstein64/vim-startuptime"

  -- Impatient, speeds up statup time by using compiling Lua modules.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use { "lewis6991/impatient.nvim" }
  -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Hacky Profiler
  use "stevearc/profile.nvim"

  use "nvim-lua/popup.nvim"

  -- Useful Lua functions, used by lots of plugins
  use "nvim-lua/plenary.nvim"

  ------------------------------------------------------------------------------
  -- Colorschemes
  ------------------------------------------------------------------------------
  use "lunarvim/darkplus.nvim"
  use "lunarvim/colorschemes"
  use "folke/tokyonight.nvim"
  use "rebelot/kanagawa.nvim"
  use "mangeshrex/everblush.vim"
  use "luisiacc/gruvbox-baby"
  use "sainnhe/gruvbox-material"
  use "cocopon/iceberg.vim"
  use "shaunsingh/oxocarbon.nvim"
  use "keith/parsec.vim"
  use "RRethy/nvim-base16"
  use "chriskempson/base16-vim"
  use "mswift42/vim-themes"
  use "lifepillar/vim-solarized8"
  -- use "lunarvim/colorschemes" -- These colorschemes are mostly broken.
  use {
    "Yagua/nebulous.nvim",
    requires = {
      { "tjdevries/colorbuddy.nvim" },
    },
    config = function()
      require "plugins.nebulous"
    end
  }
  ------------------------------------------------------------------------------
  -- Neovim Completion
  ------------------------------------------------------------------------------
  use {
    "hrsh7th/nvim-cmp",

    config = function()
      require "plugins.nvim-cmp"
    end
  }

  use "hrsh7th/cmp-nvim-lsp" -- LSP Completion.
  use "hrsh7th/cmp-path" -- Path Completions.
  use "hrsh7th/cmp-buffer" -- Buffer Completions.
  use "hrsh7th/cmp-cmdline" -- CmdLine Completions.
  use "hrsh7th/cmp-nvim-lua" -- NVIM Lua Completion.
  use "saadparwaiz1/cmp_luasnip" -- Snippet Completions.
  ------------------------------------------------------------------------------
  -- GitHub Copilot
  ------------------------------------------------------------------------------
  use {
    -- The better, Lua version of github/copilot.vim
    "zbirenbaum/copilot.lua",

    -- Startup can be slow, so good to defer.
    config = function()
      vim.defer_fn(function()
        require("plugins.github-copilot.copilot-lua")
      end, 100)
    end,

    event = { "VimEnter" },
  }


  use {
    "zbirenbaum/copilot-cmp",

    config = function()
      require "plugins.github-copilot.copilot-cmp"
    end
  }
  ------------------------------------------------------------------------------
  -- Snippets
  ------------------------------------------------------------------------------
  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"
  ---/===============================================================================================================================================================================================================================
  --| Nvim LSP (Language Server Protocol)
  --\================================================================================================================================================================================================================================
  use { "williamboman/mason.nvim", opt = false }
  use { "williamboman/mason-lspconfig.nvim", opt = false }
  use { "neovim/nvim-lspconfig", opt = false }

  use { "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" }
  }

  use { "simrat39/rust-tools.nvim",
    ft = "rust"
  }

  use { "MrcJkb/haskell-tools.nvim",
    ft = "haskell"
  }

  use { "jose-elias-alvarez/null-ls.nvim", opt = false }

  use { "ray-x/lsp_signature.nvim", opt = false }

  use {
    "hylang/vim-hy",
    event = "BufRead *.hy"
  }

  require("plugins.lsp")
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- Telescope, a fuzzy finder framework.
  ------------------------------------------------------------------------------
  use { "nvim-telescope/telescope.nvim",
    requires = { use "nvim-telescope/telescope-media-files.nvim" },
    cmd = "Telescope",
    opt = true,
    config = function() require "plugins.telescope" end
  }
  ------------------------------------------------------------------------------
  -- Treesitter, advanced language syntax engine.
  ------------------------------------------------------------------------------
  use {
    { "lewis6991/spellsitter.nvim",
      config = function() require("spellsitter").setup() end
    },

    { "nvim-treesitter/nvim-treesitter",
      config = function() require("plugins.nvim-treesitter") end
    }
  }

  use { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" }
  ------------------------------------------------------------------------------
  -- Autopairs, with integration for both nvim-cmp and nvim-treesitter.
  ------------------------------------------------------------------------------
  use { "windwp/nvim-autopairs",
    config = function() require "plugins.nvim-autopairs" end,
    after = { "nvim-cmp", "nvim-treesitter" }
  }
  ------------------------------------------------------------------------------
  -- Comment related plugins.
  ------------------------------------------------------------------------------
  use { "numToStr/Comment.nvim",
    config = function() require "plugins.comments" end,
    event = "BufEnter *"
  }

  use "JoosepAlviste/nvim-ts-context-commentstring"
  ------------------------------------------------------------------------------
  -- GitHub integration.
  ------------------------------------------------------------------------------
  use { "TimUntersberger/neogit",
    opt = true,
    requires = "nvim-lua/plenary.nvim",
    config = function() require "plugins.neogit" end
  }

  -- Shows removed/inserted/modified guides next to the line number.
  use { "lewis6991/gitsigns.nvim",
    config = function() require "plugins.gitsigns" end
  }
  ------------------------------------------------------------------------------
  -- NvimTree, project file explorer for NeoViM.
  ------------------------------------------------------------------------------
  use { "kyazdani42/nvim-tree.lua",
    requires = { { "kyazdani42/nvim-web-devicons" } },
    -- commit   = "3c4958ab3dd0e5fa470fb50b6b9cc6df48229a2e",
    config   = function() require "plugins.nvim-tree" end,
    event    = "VimEnter"
  }
  ------------------------------------------------------------------------------
  -- Lualine
  ------------------------------------------------------------------------------
  use {
    "nvim-lualine/lualine.nvim",
    config = function() require "plugins.lualine" end,
    event = "BufEnter *",
    after = { "nvim-base16" }
  }
  ------------------------------------------------------------------------------
  -- Bufferline, buffer tabs for NeoViM, emulating Doom Emacs' aesthetic.
  ------------------------------------------------------------------------------
  -- use { "akinsho/bufferline.nvim",
  --   config = function() require "plugins.nvim-bufferline" end,
  --   after = "lualine.nvim"
  -- }

  use { "noib3/nvim-cokeline",
    requires = 'kyazdani42/nvim-web-devicons',
    event = "BufEnter *",
    opt = true,
    config = function() require "plugins.nvim-cokeline" end
  }

  -- Adds the "Bdelete" and "Bwipeout" commands that can be used to delete
  -- buffers without closing the windows that have then open.
  use "moll/vim-bbye"
  ------------------------------------------------------------------------------

  use {
    "utilyre/barbecue.nvim",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function() require "plugins.barbecue-nvim" end,
  }

  -- WhichKey
  use {
    "folke/which-key.nvim",
    config = function()
      require "plugins.which-key"
    end
  }

  -- Alpha, a customizable greeter homepage for NeoViM.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "goolord/alpha-nvim",
    requires = {
      { "antoinemadec/FixCursorHold.nvim" }
    },
    config = function()
      require "plugins.alpha-nvim"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Discord Rich Presence support.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "andweeb/presence.nvim",
    config = function()
      require "plugins.presence"
    end,
    event = "BufRead *"
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Indentline, vertical indent guide lines for NeoViM.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead *",
    config = function()
      require "plugins.indent-blankline"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require "plugins.project-nvim"
    end
  }

  -- Markdown Preview
  use {
    "davidgranstrom/nvim-markdown-preview",
    ft = "markdown"
  }

  -- Papyrus Language Support
  use { "sirtaj/vim-papyrus",
    event = "BufRead *.psc"
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- should always be at the end after all plugins.
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
