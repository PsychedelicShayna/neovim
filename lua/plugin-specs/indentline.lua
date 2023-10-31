return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  event = "BufEnter",
  config = function()
    require("ibl").setup {

      indent = {
        char = '│',
      },

      scope = {
        enabled = true,
        char = '┊',
        show_start = false,
        show_end = false
      }
    }
  end
}
