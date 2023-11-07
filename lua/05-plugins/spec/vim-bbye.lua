return {
  "moll/vim-bbye",
  lazy = true,
  cmd = { "Bdelete", "Bwipeout" },
  config = false,
  init = function()
    Events.await_event {
      actor = "which-key",
      event = "configured",
      callback = function()
        local ok, wk = pcall(require, "which-key")
        if not ok then
          vim.notify("Couldn't load which-key from vim-bbye", vim.log.levels.WARN)
          return
        end

        vim.notify("vim-bbye received callback", vim.log.levels.WARN)
        wk.register({
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
      end
    }
  end
}
