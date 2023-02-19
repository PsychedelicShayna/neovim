return {
  { "moll/vim-bbye",
    lazy = true,
    cmd = {  "Bdelete",  "Bwipeout" },
    config = false,
    init = function()
      require("global.control.events").new_cb_or_call(
        "plugin-loaded",
        "which-key",
        function()
          require("which-key").register({
            d = {
              "<cmd>Bdelete<cr>",
              "Delete Buffer (Force)",
            },
            D = {
              "<cmd>Bdelete!<cr>",
              "Delete Buffer (Force)",
            }
          }, {
            prefix = "<leader>b"
          })
        end)
    end
  },
}
