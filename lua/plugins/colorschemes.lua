return {
  { "rebelot/kanagawa.nvim", priority = 900,
    event = "VimEnter",
    config = function(_, _)
      vim.cmd.colorscheme("kanagawa")
    end
  },

  { "sainnhe/gruvbox-material", lazy = true, priority = 900,
    config = function(_, _)
      vim.cmd.colorscheme("gruvbox-material") 
    end
  }
}
