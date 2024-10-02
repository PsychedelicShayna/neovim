-- local function dual_map_lsp()
--   local wk_mappings = {}
-- end

function Map_lsp_which_key(wk)
  -- local mappings = {}
  --
  -- mappings["a"] = {
  --   "<cmd>lua vim.lsp.buf.code_action()<cr>",
  --   "Code Action",
  -- }
  --
  -- mappings["D"] = {
  --   "<cmd>lua vim.lsp.buf.declaration()<cr>",
  --   "View Declaration",
  -- }
  --
  -- mappings["d"] = {
  --   "<cmd>Telescope lsp_definitions<cr>",
  --   "View Definition",
  -- }
  --
  -- -- mappings["s"] = {}
  --
  -- mappings["f"] = {
  --   "<cmd>lua vim.lsp.buf.format { async = true }<cr>",
  --   "Format",
  -- }
  --
  -- mappings["h"] = {
  --   "<cmd>lua vim.lsp.buf.hover()<cr>",
  --   "Hover Over",
  -- }
  --
  -- -- client.config.handlers["textDocument/hover"] = vim.lsp.with(
  -- --   vim.lsp.handlers.hover, {
  -- --     border = "single",
  -- --     title = ' ' .. client.config.name .. ' '
  -- --   }
  -- -- )
  --
  -- mappings["i"] = {
  --   "<cmd>lua vim.lsp.buf.implementation()<cr>",
  --   "View Implementation",
  -- }
  --
  -- mappings["R"] = {
  --   "<cmd>Telescope lsp_references<cr>",
  --   "Find References"
  -- }
  --
  -- mappings["r"] = {
  --   "<cmd>lua vim.lsp.buf.rename()<cr>",
  --   "Rename Symbol",
  -- }
  --
  -- mappings["S"] = {
  --   "<cmd>lua vim.lsp.buf.signature_help()<cr>",
  --   "View Signature",
  -- }
  --
  -- mappings["W"] = {
  --   "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
  --   "Find Workspace Symbols",
  -- }
  --
  -- mappings["F"] = {
  --   "<cmd>:ToggleAutoFormat<cr>",
  --   "Toggle AutoFormat"
  -- }
  --

  local mappings = {
    { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>",           desc = "View Declaration" },
    { "<leader>lF", "<cmd>:ToggleAutoFormat<cr>",                       desc = "Toggle AutoFormat" },
    { "<leader>lR", "<cmd>Telescope lsp_references<cr>",                desc = "Find References" },
    { "<leader>lS", "<cmd>lua vim.lsp.buf.signature_help()<cr>",        desc = "View Signature" },
    { "<leader>lW", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Find Workspace Symbols" }, { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",           desc = "Code Action" }, { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>",               desc = "View Definition" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", desc = "Format" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>",                 desc = "Hover Over" },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>",        desc = "View Implementation" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",                desc = "Rename Symbol" },
  }

  wk.add(mappings) -- {
  --   prefix = "<leader>l",
  -- wk.register(mappings, {
  -- })
end

-- Temporary Solution:
-------------------------------------------------------------------------------
Events.await_event {
  actor = "which-key",
  event = "configured",
  retroactive = true,
  callback = function(_)
    Safe.try(function(_)
      Map_lsp_which_key(require('which-key'))
    end)
  end,

}
-------------------------------------------------------------------------------
