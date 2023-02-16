-- Bootstap the lazy.nvim plugin manager onto Neovim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
  vim.notify("cannot initialize lazy.nvim yet, please restart neovim.")
  return
end

-- Load keybindings before plugins, since it contains leader key definition.
pcall(require, "userconf.keybindings")

-- Load Lazy.nvim
require("lazy").setup {
  change_detection = {
    notify = false
  },
  spec = { import = "plugins" },
  install = {
    colorscheme = { "kanagawa" }
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}

-- Load the Neovim options that should be set after plugins are loaded.
pcall(require, "userconf.colorscheme")
pcall(require, "userconf.neovide")
pcall(require, "userconf.options")
pcall(require, "userconf.lsp")
