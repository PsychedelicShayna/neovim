
local function dual_map_lsp()
  local wk_mappings = {}
end

function Map_lsp_which_key(wk)
  local mappings = {}

  mappings["a"] = {
    "<cmd>lua vim.lsp.buf.code_action()<cr>",
    "Code Action",
  }

  mappings["D"] = {
    "<cmd>lua vim.lsp.buf.declaration()<cr>",
    "View Declaration",
  }

  mappings["d"] = {
    "<cmd>Telescope lsp_definitions<cr>",
    "View Definition",
  }

  mappings["s"] = {}

  mappings["f"] = {
    "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
    "Format",
  }

  mappings["h"] = {
    "<cmd>lua vim.lsp.buf.hover()<cr>",
    "Hover Over",
  }

  -- client.config.handlers["textDocument/hover"] = vim.lsp.with(
  --   vim.lsp.handlers.hover, {
  --     border = "single",
  --     title = ' ' .. client.config.name .. ' '
  --   }
  -- )

  mappings["i"] = {
    "<cmd>lua vim.lsp.buf.implementation()<cr>",
    "View Implementation",
  }

  mappings["R"] = {
    "<cmd>Telescope lsp_references<cr>",
    "Find References"
  }

  mappings["r"] = {
    "<cmd>lua vim.lsp.buf.rename()<cr>",
    "Rename Symbol",
  }

  mappings["s"] = {
    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    "View Signature",
  }

  mappings["W"] = {
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    "Find Workspace Symbols",
  }

  mappings["F"] = {
    "<cmd>:ToggleAutoFormat<cr>",
    "Toggle AutoFormat"
  }

  wk.register(mappings, {
    prefix = "<leader>l",
    mode = "n",
  })
end

-- events.run_after("setup", "which-key", function()
--   local wk_ok, wk = pcall(require, 'which-key')
--
--   if wk_ok then
--     Map_lsp_which_key(wk)
--   else
--     vim.notify("LSP Keybinding Failure")
--     print("LSP Keybinding Failure")
--     -- Get line number
--     local line = debug.getinfo(1).currentline
--     -- Get file name
--     local file = debug.getinfo(1).source:match("@(.*)$")
--
--     vim.notify("Received setup event from which-key, failed to import which-key in callback!", vim.log.levels.WARN)
--     vim.notify("Line: " .. line)
--     vim.notify(file)
--   end
-- end)
