-- Builtins: https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins

return function(null_ls)
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local completion = null_ls.builtins.completion
  local hover = null_ls.builtins.hover

  null_ls.setup {
    debug = false,

    on_init = function(new_client, _)
      -- vim.notify(new_client)
      -- new_client.offset_encoding = "utf-16"
    end,

    sources = {
      -- C++
      diagnostics.cppcheck,

      -- Elixr
      formatting.mix,
      diagnostics.credo.with {
        command = "mix.bat"
      },

      -- Other
      diagnostics.jsonlint,
      code_actions.gitsigns,
    },
  }
end
