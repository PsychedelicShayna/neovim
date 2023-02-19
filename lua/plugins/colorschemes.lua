local selected_colorscheme = "tokyonight-night"

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("tokyonight")
    vim.cmd.colorscheme(selected_colorscheme)

    require("global.control.events").fire("colorscheme", "loaded", 2, {
      name = selected_colorscheme
    })
  end
})

-- "base16-gotham" -- Best with window transparency.

return {
  { "rebelot/kanagawa.nvim",    lazy = true },
  { "folke/tokyonight.nvim",    lazy = true },
  { "NvChad/base46",            lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
}
