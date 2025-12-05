vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go" },
    callback = function(opts)
        local settings = "lead:.,tab:  ,trail:-,nbsp:+"
        vim.notify("Setting local listchars for buffer " .. opts.buf .. " to=" .. settings)
        vim.api.nvim_set_option_value("listchars", settings, { scope = "local" })
    end
})
