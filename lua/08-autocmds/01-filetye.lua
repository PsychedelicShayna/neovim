vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "go" },
  callback = function(opts)
    local settings = "lead:.,tab:  ,trail:-,nbsp:+"
    vim.notify("Setting local listchars for buffer " .. opts.buf .. " to=" .. settings)
    vim.api.nvim_set_option_value("listchars", settings, { scope = "local" })

    vim.api.nvim_create_user_command("ToggleAutoOrganizeImports", function()
      if type(_G.autocmd_id_toggle_auto_organize_imports) == "number" then
        vim.api.nvim_del_autocmd(_G.autocmd_id_toggle_auto_organize_imports)
        _G.autocmd_id_toggle_auto_organize_imports = nil
        vim.notify("Toggled off.")
      else
        _G.autocmd_id_toggle_auto_organize_imports = vim.api.nvim_create_autocmd({ "BufWritePre" }, {
          callback = function()
            vim.lsp.buf.code_action {
              context = { only = { "source.organizeImports" } },
              apply = true,
            }
          end,
        })
        vim.notify("Toggled on.")
      end
    end, {})

    MapKey { key = "<leader>lg",
      does = function()
        vim.lsp.buf.code_action {
          context = { only = { "source.organizeImports" } },
          apply = true,
        }
      end,
      modes = "n",
      desc = "Go Organize Imports"
    }

    MapKey { key = "<leader>lG",
      does = "<cmd>ToggleAutoOrganizeImports<cr>",
      modes = "n",
      desc = "Toggle Auto Organize Imports"
    }
  end
})
