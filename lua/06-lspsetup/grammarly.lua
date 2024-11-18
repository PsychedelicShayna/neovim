return function(grammarly, caps, on_attach)
  grammarly.setup {
    -- filetypes = "*",
    autostart = false,
    capabilities = caps,
    on_attach = on_attach
  }
end

-- {
--   _setup_buffer = <function 1>,
--   commands = <1>{},
--   document_config = {
--     commands = <table 1>,
--     default_config = {
--       cmd = { "cmd.exe", "/C", "grammarly-languageserver", "--stdio" },
--       filetypes = { "markdown" },
--       handlers = {
--         ["$/updateDocumentState"] = <function 2>
--       },
--       init_options = {
--         clientId = "client_BaDkMgx4X19X9UxxYRCXZo"
--       },
--       root_dir = <function 3>,
--       single_file_support = true
--     },
--     docs = {
--       default_config = {
--         root_dir = "util.find_git_ancestor"
--       },
--       description = "https://github.com/znck/grammarly\n\n`grammarly-languageserver` can be installed via `npm`:\n\n```sh\nnpm i -g grammarly-languageserver\n```\n\nWARNING: Since this language server uses Grammarly's API, any document you open with it running is shared with them. Please evaluate their [privacy policy](https://www.grammarly.com/privacy-policy) before using this.\n"
--     }
--   },
--   name = "grammarly",
--   setup = <function 4>
-- }
