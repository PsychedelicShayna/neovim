local events = require('lib.events')

return function(rust_analyzer, caps, on_attach)
  local root_pattern = require("lspconfig.util").root_pattern

  local config = {
    on_attach    = on_attach,
    capabilities = caps,
    cmd          = { "rust-analyzer" },
    filetypes    = { "rust" },
    root_dir     = root_pattern("Cargo.toml", "rust-project.json"),
    settings     = {
      ["rust-analyzer"] = {}
    }
  }

  local rust_tools_present, rust_tools = pcall(require, "rust-tools")

  if rust_tools_present then
    local extended_config = vim.deepcopy(config)

    extended_config.on_attach = function(client, bufnr)
      events.run_after("configured", "which-key", function(_)
        local which_key = require('which-key')
        which_key.register({
          I = {
            name = 'Inlay Hints...',
            E = {
              "<cmd>lua require('rust-tools').inlay_hints.enable()<cr>",
              "Enable Globally"
            },
            D = {
              "<cmd>lua require('rust-tools').inlay_hints.disable()<cr>",
              "Disable Globally"
            },
            e = {
              "<cmd>lua require('rust-tools').inlay_hints.set()<cr>",
              "Enable for Buffer"
            },
            d = {
              "<cmd>lua require('rust-tools').inlay_hints.unset()<cr>",
              "Disable for Buffer"
            }
          },
          m = {
            "<cmd>lua require('rust-tools').expand_macro.expand_macro()<cr>",
            "Expand Macro"
          },
          c = {
            "<cmd>lua require('rust-tools').open_cargo_toml.open_cargo_toml()<cr>",
            "Open Cargo.toml"
          },
          p = {
            "<cmd>lua require('rust-tools').parent_module.parent_module()<cr>",
            "Parent Module"
          }
        }, {
          prefix = '<leader>l',
          mode = 'n',
          buffer = bufnr
        })
      end)

      on_attach(client, bufnr)
    end

    rust_tools.setup {
      tools = {
        inlay_hints = {
          auto = true,
          show_parameter_hints = true,
          only_current_line = false,
          highlight = "comment"
        }
      },
      server = extended_config
    }
  else
    rust_analyzer.setup(config)
    vim.notify('Did not use rust-tools')
  end

  return true
end
