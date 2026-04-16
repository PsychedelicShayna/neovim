vim.api.nvim_create_autocmd("FileType", {
  pattern = "teal",
  callback = function(args)
    vim.lsp.start({
      name = "teal-ls",
      cmd = { "teal-language-server" },
      root_dir = vim.fs.dirname(
        vim.fs.find({ ".git", "tlconfig.lua" }, { upward = true })[1]
      ),
    })
  end,
})
