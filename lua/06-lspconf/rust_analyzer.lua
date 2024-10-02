return function(rust_analyzer, caps, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

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

  local use_rust_tools = false

  if not use_rust_tools then
      rust_analyzer.setup(config)
      return true
  end

  Safe.import_then("rust-tools", function(rt)
    local original = config.on_attach

    config.on_attach = function(client, bufnr)

      Events.await_event {
        actor = "which-key",
        event = "configured",
        retroactive = true,
        callback = function()
          Safe.import_then('which-key', function(wk)
            wk.add {
              { "<leader>lI",  group = "[Inlay Hints]" },
              { "<leader>lIE", "<cmd>lua require('rust-tools').inlay_hints.enable()<cr>",              desc = "Enable Globally",    buffer = bufnr },
              { "<leader>lID", "<cmd>lua require('rust-tools').inlay_hints.disable()<cr>",             desc = "Disable Globally",   buffer = bufnr },
              { "<leader>lIe", "<cmd>lua require('rust-tools').inlay_hints.set()<cr>",                 desc = "Enable for Buffer",  buffer = bufnr },
              { "<leader>lId", "<cmd>lua require('rust-tools').inlay_hints.unset()<cr>",               desc = "Disable for Buffer", buffer = bufnr },
              { "<leader>lm",  "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>",       desc = "Expand Macro",       buffer = bufnr },
              { "<leader>lC",  "<cmd>lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>", desc = "Open Cargo.toml",    buffer = bufnr },
              { "<leader>lp",  "<cmd>lua require('rust-tools').parent_module.parent_module()<cr>",     desc = "Parent Module",      buffer = bufnr },
            }
          end) -- Import Then
        end,   -- Callback
      }

      original(client, bufnr)
    end -- on_attach


    rt.setup({
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

    -- import_then
  end, {
    trace = false,
    handle = function()
      rust_analyzer.setup(config)
    end -- handle
  })

  return true
end -- returned function
