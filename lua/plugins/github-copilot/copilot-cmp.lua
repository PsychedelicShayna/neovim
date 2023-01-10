local copilot_cmp_ok, copilot_cmp = pcall(require, "copilot_cmp")

if not copilot_cmp_ok then
  vim.notify("Could not import copilot_cmp from plugins/github-copilot/copilot-cmp.lua")
  return
end

copilot_cmp.setup({
  method = "getCompletionsCycling",
})
