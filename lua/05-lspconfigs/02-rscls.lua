-- I got tired of misspelling it. Please, pick a better name, e.g. rssls, or
-- rsscls if you you worry about colliding with RSS feeds, though that doesn't
-- make much sense either; why tf would an RSS feed need a language server???
-- Or just rustscript-ls, there. Done. Mangling the "s" from "rs" with the "s"
-- from "script" and then putting a "c" to make "script" deducible, while also
-- accidentally having included a DOS command in the name.. Just.. rssls, pls.
local SERVER_NAME       = "rscls"
local SERVER_BIN        = "rscls"

-- Then I figured I might as well put the other names here, since this is a
-- non-standard file type, with an unofficial extension. Best keep it strict.
local FILETYPE          = 'rustscript'
local FILETYPE_EXT_GLOB = '*.ers'

-- Since *.ers files are not recognized as RustScript files, we need to make
-- an autocmd to set the filetype to rustscript for *.ers files.
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = FILETYPE_EXT_GLOB,
  callback = function()
    vim.bo.filetype = FILETYPE
  end
})

Events.await_event {
  actor = "lspconfig",
  event = "configured",
  retroactive = true,
  callback = function()
    local lspconfig = require("lspconfig")
    local configs   = require("lspconfig.configs")

    if not configs.rscls then
      configs.rscls = {
        default_config = {
          cmd = { 'rscls' },
          filetypes = { 'rustscript' },
          root_dir = function(fname)
            return lspconfig.util.path.dirname(fname)
          end,
        },
        docs = {
          description = "WIP Scuffed language server for rust-script, by MiSawa/rscls"
        }
      }
    end

    Events.fire_event {
      actor = "rscls",
      event = "registered"
    }
  end
}

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = 'rustscript',
  callback = function(_)
    vim.bo.syntax = "rust"

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
          PrintDbg("No extended capabilities provided for rscls", LL_WARN)
        end

        if custom_on_attach then
          setup_opts.on_attach = custom_on_attach
        else
          PrintDbg("No custom_on_attach function provided for rscls", LL_WARN)
        end

        Events.await_event {
          actor = "rscls",
          event = "registered",
          retroactive = true,
          callback = function()
            local configs  = require("lspconfig.configs")
            local ls_entry = configs.rscls
            ls_entry.setup(setup_opts)
          end
        }
      end
    }
  end
})
