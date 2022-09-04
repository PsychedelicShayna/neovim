local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,

  on_init = function(new_client, _)
    vim.notify(new_client)
    --[[ new_client.offset_encoding = "utf-16" ]]
  end,

  sources = {
    -- C++
    -- formatting.clang_format,
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
