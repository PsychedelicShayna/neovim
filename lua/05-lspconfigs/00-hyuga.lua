Events.await_event {
  actor = "lspconfig",
  event = "configured",
  retroactive = true,
  callback = function()
    local lspconfig = require("lspconfig")
    local configs   = require("lspconfig.configs")

    if not configs.hy then
      configs.hy = {
        default_config = {
          cmd = { 'hyuga' },
          filetypes = { 'hy' },
          root_dir = function(fname)
            return lspconfig.util.path.dirname(fname)
          end,
        },
        docs = {
          description = "Hyuga language server for the Hy LISP dialect of Python."
        }
      }
    end

    Events.fire_event {
      actor = "hyuga",
      event = "registered"
    }
  end
}

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = 'hy',
  callback = function(_)
    vim.bo.syntax = "hy"

    Events.await_event {
      actor = "lspconfig",
      event = "custom",
      retroactive = true,
      callback = function(data)
        local capabilities     = data.capabilities or nil
        local custom_on_attach = data.custom_on_attach or nil
        local setup_opts       = {}

        if capabilities then
          setup_opts.capabilities = capabilities
        else
          PrintDbg("No extended capabilities provided for hyuga", LL_WARN)
        end

        if custom_on_attach then
          setup_opts.on_attach = custom_on_attach
        else
          PrintDbg("No custom_on_attach function provided for hyuga", LL_WARN)
        end

        Events.await_event {
          actor = "hyuga",
          event = "registered",
          retroactive = true,
          callback = function()
            local configs  = require("lspconfig.configs")
            local ls_entry = configs.hy
            ls_entry.setup(setup_opts)
          end
        }
      end
    }
  end
})
