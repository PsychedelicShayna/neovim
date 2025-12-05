-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("highlight NormalFloat ctermbg=None guibg=None cterm=None")
      vim.cmd("highlight FloatBorder ctermbg=None guibg=None cterm=None")
    end, 150)
  end
})

-------------------------------------------------------------------------------
-- Sign Definitions
-------------------------------------------------------------------------------
-- vim.diagnostic.config().signs.text = {
--   [vim.diagnostic.severity.ERROR] = 'E',
--   [vim.diagnostic.severity.WARN] = 'W',
--   [vim.diagnostic.severity.HINT] = 'H',
--   [vim.diagnostic.severity.INFO] = 'I',
-- }

--
-------------------------------------------------------------------------------
-- LSP Floating Window Settings
-------------------------------------------------------------------------------

-- local float_border = {
--   { "╭", "FloatBorder" },
--   { "─", "FloatBorder" },
--   { "╮", "FloatBorder" },
--   { "│", "FloatBorder" },
--   { "╯", "FloatBorder" },
--   { "─", "FloatBorder" },
--   { "╰", "FloatBorder" },
--   { "│", "FloatBorder" },
-- }

-- Apply default LSP floating window options
vim.lsp.util.open_floating_preview = (function(orig)
  return function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = float_border or 'single'
    return orig(contents, syntax, opts, ...)
  end
end)(vim.lsp.util.open_floating_preview)

-------------------------------------------------------------------------------
-- Diagnostics Config
-------------------------------------------------------------------------------
vim.diagnostic.config {


  virtual_text = false,
  signs = { active = diagnostic_signs },
  update_in_insert = false,
  underline = false,
  severity_sort = true, -- default: false
  float = {
    virtual_text = true,
    focusable    = true,
    focus        = true,
    style        = "minimal",
    border       = "single",
    kjsource     = true,
    header       = '_',
    prefix       = '',
  },
}
