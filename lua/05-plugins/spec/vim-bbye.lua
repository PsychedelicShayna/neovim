return {
  "moll/vim-bbye",
  lazy = true,
  cmd = { "Bdelete", "Bwipeout" },
  config = false,
  init = function()
    Events.await_event {
      actor = "which-key",
      event = "configured",
      retroactive = true,
      callback = function()
        local ok, wk = pcall(require, "which-key")

        if not ok then
          vim.notify("Couldn't load which-key from vim-bbye (cannot import which-key)", vim.log.levels.ERROR)
          return
        end

        wk.add {
          { "<leader>bD", "<cmd>Bdelete!<cr>", desc = "Delete Buffer (Force)" },
          { "<leader>bd", "<cmd>Bdelete<cr>",  desc = "Delete Buffer (Force)" },
          --
          -- d = {
          --   "<cmd>Bdelete<cr>",
          --   "Delete Buffer (Force)",
          -- },
          -- D = {
          --   "<cmd>Bdelete!<cr>",
          --   "Delete Buffer (Force)",
          -- }
        }
        -- }, {
        --   prefix = "<leader>b"
        -- })
      end
    }
  end
}
