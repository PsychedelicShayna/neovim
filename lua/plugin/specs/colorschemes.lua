local events = require("prelude").events

local colorschemes = {
  { "EdenEast/nightfox.nvim",           lazy = true },
  { "FrenzyExists/aquarium-vim",        lazy = true },
  { "LunarVim/Colorschemes",            lazy = true },
  { "LunarVim/horizon.nvim",            lazy = true },
  { "LunarVim/onedarker.nvim",          lazy = true },
  { "LunarVim/synthwave84.nvim",        lazy = true },
  { "Mofiqul/dracula.nvim",             lazy = true },
  { "RRethy/nvim-base16",               lazy = true },
  { "Shatur/neovim-ayu",                lazy = true },
  { "andersevenrud/nordic.nvim",        lazy = true },
  { "bluz71/vim-nightfly-colors",       lazy = true },
  { "catppuccin/nvim",                  lazy = true },
  { "doki-theme/doki-theme-vim",        lazy = true },
  { "fenetikm/falcon",                  lazy = true },
  { "folke/tokyonight.nvim",            lazy = true },
  { "jdsimcoe/hyper.vim",               lazy = true },
  { "kvrohit/rasmus.nvim",              lazy = true },
  { "lalitmee/cobalt2.nvim",            lazy = true },
  { "lunarvim/darkplus.nvim",           lazy = true },
  { "neanias/everforest-nvim",          lazy = true },
  { "numToStr/Sakura.nvim",             lazy = true },
  { "nyoom-engineering/oxocarbon.nvim", lazy = true },
  { "projekt0n/github-nvim-theme",      lazy = true },
  { "rebelot/kanagawa.nvim",            lazy = true },
  { "sainnhe/gruvbox-material",         lazy = true },
  { "srcery-colors/srcery-vim",         lazy = true },
  { "titanzero/zephyrium",              lazy = true },
  { "whatyouhide/vim-gotham",           lazy = true },
  { "yazeed1s/minimal.nvim",            lazy = true }
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
