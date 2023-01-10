return function(lspconfig, on_attach, default_capabilities)
  if not lspconfig.hls then
    vim.notify("Cannot setup hls because lspconfig does not define it.")
    return
  end

  local ht_ok, ht = pcall(require, "haskell-tools")
  local def_opts = { noremap = true, silent = true, }

  local default_config = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)

      local opts = vim.tbl_extend('keep', def_opts, { buffer = bufnr, })
      vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, opts)

      if ht_ok then
        vim.keymap.set('n', '<space>ho', ht.hoogle.hoogle_signature, opts)
      end
    end,

    capabilities        = default_capabilities,
    cmd                 = { "haskell-language-server-wrapper", "--lsp" },
    filetypes           = { "haskell", "lhaskell" },
    root_dir            = function(filepath)
      return lspconfig.util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project')(filepath)
          or lspconfig.util.root_pattern('*.cabal', 'package.yaml')(filepath)
    end,
    settings            = {
      haskell = {
        cabalFormattingProvider = "cabalfmt",
        formattingProvider = "ormolu"
      }
    },
    single_file_support = true
  }

  if ht_ok then
    local return_value = ht.setup {
      hls = default_config
    }

    vim.keymap.set('n', '<leader>rr', ht.repl.toggle, def_opts)
    vim.keymap.set('n', '<leader>rq', ht.repl.quit, def_opts)

    vim.keymap.set('n', '<leader>rf', function()
      ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end, def_opts)

    return return_value
  else
    return lspconfig.hls.setup(default_config)
  end
end
