return function(rust_analyzer, caps, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern


  local use_rustaceanvim = true

  if use_rustaceanvim then
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()

        vim.g.rustaceanvim = {
          tools = {
            Opts = {
              float_win_config = {
                border = 'single',
                auto_focus = true
              }
            }
          }
        }

        MapKey { key = "<Leader>la", does = "<cmd>lua vim.cmd.RustLsp('codeAction')<cr>", modes = 'n', desc = "Code Actions (Rust)", opts = { buffer = bufnr, silent = true } }
        MapKey { key = "<Leader>lh", does = "<cmd>lua vim.cmd.RustLsp({'hover', 'actions'})<cr>", modes = 'n', desc = "Hover (Rust)", opts = { buffer = bufnr, silent = true } }
        MapKey { key = "<Leader>df", does = "<cmd>lua vim.cmd.RustLsp({'renderDiagnostic', 'cycle'})<cr>", modes = 'n', desc = "Expand Diagnostic Window (Rust)", opts = { buffer = bufnr, silent = true } }
      end
    })

    return true
  end

  local config = {
    on_attach = on_attach,
    capabilities = caps,
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
      ["rust-analyzer"] = {},
    },
  }

  local use_rust_tools = true

  if not use_rust_tools then
    rust_analyzer.setup(config)
    return true
  end

  local ok, rust_tools = pcall(require, "rust-tools")

  if not ok then
    PrintDbg("Cannot import RustTools", LL_ERROR)
    return false
  end

  local original = config.on_attach


  config.on_attach = function(client, bufnr)
    Events.await_event {
      actor = "which-key",
      event = "configured",
      callback = function()
        local wk = require("which-key")
        wk.add { { "<leader>lI", group = "[Inlay Hints]" } }
      end
    }

    MapKey { key = "<leader>lIE", does = "<cmd>lua require('rust-tools').inlay_hints.enable()<cr>", modes = "n", opts = { desc = "Enable Globally", buffer = bufnr } }
    MapKey { key = "<leader>lID", does = "<cmd>lua require('rust-tools').inlay_hints.disable()<cr>", modes = "n", opts = { desc = "Disable Globally", buffer = bufnr } }
    MapKey { key = "<leader>lIe", does = "<cmd>lua require('rust-tools').inlay_hints.set()<cr>", modes = "n", opts = { desc = "Enable for Buffer", buffer = bufnr } }
    MapKey { key = "<leader>lId", does = "<cmd>lua require('rust-tools').inlay_hints.unset()<cr>", modes = "n", opts = { desc = "Disable for Buffer", buffer = bufnr } }
    MapKey { key = "<leader>lm", does = "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>", modes = "n", opts = { desc = "Expand Macro", buffer = bufnr } }
    MapKey { key = "<leader>lC", does = "<cmd>lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>", modes = "n", opts = { desc = "Open Cargo.toml", buffer = bufnr } }
    MapKey { key = "<leader>lp", does = "<cmd>lua require('rust-tools').parent_module.parent_module()<cr>", modes = "n", opts = { desc = "Parent Module", buffer = bufnr } }

    original(client, bufnr)
  end -- on_attach

  rust_tools.setup({
    server = config,
    tools = {
      inlay_hints = {
        auto = true,
        show_parameter_hints = true,
        only_current_line = true,
        highlight = "comment",
      },
    }
  })

  return true
end -- returned function
