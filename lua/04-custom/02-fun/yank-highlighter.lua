vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    -- 128ms seems to feel the smoothest and most appealing. Funny that it
    -- ended up being a power of two; maybe it's a cognitive bias that makes
    -- it feel smoother than 127 or 129. Silly humans :p

    vim.highlight.on_yank { higroup = "Search", timeout = 128 }
  end
})
