vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = { "go" },
  callback = function(_)
    vim.cmd("set tabstop=4")
  end
})
