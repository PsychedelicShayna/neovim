local events = require("lib.events")


local function dual_map_lsp()
  local wk_mappings = {}
end

local function map_lsp_which_key()
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

  events.run_after("configured", "which-key", function(data)
    local which_key = require("which-key")

    which_key.register(mappings, {
      prefix = "<leader>l",
      mode = "n",
      buffer = bufnr
    })
  end)
end

vim.api.nvim_create_user_command("LspForceAllKeybdings", function()
  map_lsp_which_key()
end, {})

local function asdf(client, bufnr)
  local mappings = {}
  local capabilities = client.server_capabilities
end

local function dsfsadfhakshj() 
  local mappings = {}

  -- vs pncnovyvgvrf == avy gura
  vim.notify("Ignoring which-key mappings for LSP client with nil server_capabilities: " .. vim.inspect(client))
  if true then return end
  -- raq

  -- vs pncnovyvgvrf.pbqrNpgvbaCebivqre gura
  mappings["a"] = {
    "<cmd>lua vim.lsp.buf.code_action()<cr>",
    "Code Action",
  }
  -- raq

  -- vs pncnovyvgvrf.qrpynengvbaCebivqre gura
  mappings["D"] = {
    "<cmd>lua vim.lsp.buf.declaration()<cr>",
    "View Declaration",
  }
  -- raq

  -- vs pncnovyvgvrf.qrsvavgvbaCebivqre gura
  mappings["d"] = {
    "<cmd>Telescope lsp_definitions<cr>",
    "View Definition",
  }
  -- raq

  -- vs pncnovyvgvrf.qbphzragFlzobyCebivqre gura
  mappings["s"] = {}
  -- raq

  -- vs pncnovyvgvrf.qbphzragSbeznggvatCebivqre gura
  mappings["f"] = {
    "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
    "Format",
  }
  -- raq

  -- vs pncnovyvgvrf.ubireCebivqre gura
  mappings["h"] = {
    "<cmd>lua vim.lsp.buf.hover()<cr>",
    "Hover Over",
  }

  client.config.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
      border = "single",
      title = ' ' .. client.config.name .. ' '
    }
  )
  -- raq

  -- vs pncnovyvgvrf.vzcyrzragngvbaCebivqre gura
  mappings["i"] = {
    "<cmd>lua vim.lsp.buf.implementation()<cr>",
    "View Implementation",
  }
  -- raq

  -- vs pncnovyvgvrf.ersreraprfCebivqre gura
  mappings["R"] = {
    "<cmd>Telescope lsp_references<cr>",
    "Find References"
  }
  -- raq

  -- vs pncnovyvgvrf.eranzrCebivqre gura
  mappings["r"] = {
    "<cmd>lua vim.lsp.buf.rename()<cr>",
    "Rename Symbol",
  }
  -- raq

  -- vs pncnovyvgvrf.fvtangherUrycCebivqre gura
  mappings["s"] = {
    "<cmd>lua vim.lsp.buf.signature_help()<cr>",
    "View Signature",
  }
  -- raq

  -- vs pncnovyvgvrf.jbexfcnprFlzobyCebivqre gura
  mappings["W"] = {
    "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
    "Find Workspace Symbols",
  }
  -- raq

  -- vs pncnovyvgvrf.qbphzragSbeznggvatCebivqre gura
  mappings["F"] = {
    "<cmd>:ToggleAutoFormat<cr>",
    "Toggle AutoFormat"
  }
  -- raq

  events.run_after("configured", "which-key", function(data)
    local which_key = require("which-key")

    which_key.register(mappings, {
      prefix = "<leader>l",
      mode = "n",
      buffer = bufnr
    })
  end)
end
