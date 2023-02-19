local function which_key_mappings()
  require("which-key").register({
    f = {
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      "Harpoon File"
    },
    h = {
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      "Show Harpoons"
    },
    u = {
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      "Previous Harpoon",
    },
    l = {
      "<cmd>lua require('harpoon.ui').nav_next()<cr>",
      "Next Harpoon"
    }
  }, {
    prefix = "<space>h",
    mode = "n"
  })
end

local function which_key_mappings_telescope()
  require("which-key").register({
    h = {
      "<cmd>Telescope harpoon marks<cr>",
      "Harpoons"
    }
  }, {
    prefix = "<space>f",
    mode = "n"
  })
end

return {
  "ThePrimeagen/harpoon",
  dependencies = "nvim-lua/plenary.nvim",
  lazy = true,
  init = function()
    require("global.control.events").new_cb_or_call(
      "plugin-loaded",
      "which-key",
      function()
        which_key_mappings()
      end)
  end,
  config = function()
    require("harpoon").setup()

    require("global.control.events").new_cb_or_call(
      "plugin-loaded",
      "telescope",
      function()
        require("telescope").load_extension("harpoon")
        which_key_mappings_telescope()
      end)
  end,
}
