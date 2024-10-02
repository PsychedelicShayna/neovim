return {
  "ellisonleao/glow.nvim",
  cmd = "Glow",
  keys = "gL",
  config = function()
    Safe.import_then("glow", function(glow)
      Safe.try(function()
        glow.setup {
          glow_path       = "/usr/bin/glow",
          install_path    = "~/.local/state/nvim/dep",
          border          = "single",
          -- style        = "dark|light",  -- Determined automatically if unset.
          -- pager        = false,
          -- width        = 80,
          -- height       = 100,
          -- height_ratio = 0.7,           -- Maximum height relative to Neovim.
        }
      end)
          -- width_ratio  = 0.7,           -- Maximum width relative to Neovim.
      MapKey { in_mode = "n", key = "gL", does = ":Glow<CR>" }
    end)
  end
}
