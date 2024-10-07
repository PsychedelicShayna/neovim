vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
  callback = function()
    local x = io.open("/tmp/signal", "r")

    if x then
      x:close()
      vim.cmd("!rm /tmp/signal -f")
      vim.cmd("qa!")
    end
  end
})
