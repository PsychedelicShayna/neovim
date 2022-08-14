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
  display = {
    -- Use a popup window for the packer GUI.
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- AutoCommand that reloads NeoViM when you update this init.lua file, such as
-- when adding or removing a plugin, ensuring that any changes to the file are
-- immediately reflected in NeoViM.
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--                          Packer Plugin List
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return packer.startup(function(use)
  -- Have packer manage itself.
  use "wbthomason/packer.nvim"

  -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/popup.nvim"

  -- Useful Lua functions, used by lots of plugins
  use "nvim-lua/plenary.nvim"

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "lunarvim/colorschemes"
  use "folke/tokyonight.nvim"
  use "rebelot/kanagawa.nvim"
  use "mangeshrex/everblush.vim"
  use "luisiacc/gruvbox-baby"
  use "sainnhe/gruvbox-material"
  use "cocopon/iceberg.vim"

  -- Completion framework for NeoViM, with many extensions for it.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },       -- Buffer Completions.
      { "hrsh7th/cmp-path" },         -- Path Completions.
      { "hrsh7th/cmp-cmdline" },      -- CmdLine Completions.
      { "saadparwaiz1/cmp_luasnip" }, -- Snippet Completions.
      { "hrsh7th/cmp-nvim-lua" },     -- NVIM Lua Completion.
      { "hrsh7th/cmp-nvim-lsp" }      -- NVIM Lua Completion.
    },
    config = function()
      require "plugins.nvim-cmp"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Snippets
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Language Server(s)
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "neovim/nvim-lspconfig", -- Official config for enabling LSP in NeoViM.
    requires = {
      { "williamboman/nvim-lsp-installer" }, -- LSP language installer UI.
      { "jose-elias-alvarez/null-ls.nvim" }  -- Non-LSP language servers.
    },
    config = function()
      require "plugins.lsp"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Telescope
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      use "nvim-telescope/telescope-media-files.nvim"
    },
    config = function()
      require "plugins.telescope"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Treesitter, advanced language syntax tree engine.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      { "lewis6991/spellsitter.nvim" },
      { "p00f/nvim-ts-rainbow" }
    },
    config = function()
      require "plugins.nvim-treesitter"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Autopairs, with integration for both nvim-cmp and nvim-treesitter.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "plugins.nvim-autopairs"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Automatic comments.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "numToStr/Comment.nvim",
    requires = {
      { "JoosepAlviste/nvim-ts-context-commentstring" }
    },
    config = function()
      require "plugins.comment"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- GitHub integration.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Shows removed/inserted/changed guides on the left.
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "plugins.gitsigns"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- NvimTree, project root file explorer for NeoViM.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      { "kyazdani42/nvim-web-devicons" }
    },
    config = function()
      require "plugins.nvim-tree"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Bufferline, buffer tabs for NeoViM, emulating Doom Emacs' aesthetic.
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  use {
    "akinsho/bufferline.nvim",
    requires = {
      { "moll/vim-bbye" }
    },
    config = function()
     require "plugins.nvim-bufferline"
    end
  }
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- Toggleterm
  use {
    "akinsho/toggleterm.nvim",
    config = function()
      require "plugins.toggleterm"
    end
  }

  -- Lualine
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require "plugins.lualine"
    end
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

  -- Markdown Preview
  use "davidgranstrom/nvim-markdown-preview"

  -- Papyrus Language Support
  use "sirtaj/vim-papyrus"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
