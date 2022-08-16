local copilot_ok, copilot = pcall(require, "copilot")
if not copilot_ok then
  vim.notify("Could not import copilot from plugins/copilot-lua/copilot-lua.lua")
  return
end

copilot.setup {
  cmp = {
    enabled = true,
    method = "getCompletionsCycling", -- "getCompletionsCycling" recommended,
  },
  panel = { -- no config options yet
    enabled = true,
  },
  -- Prevent copilot from attaching to buffers with certain file extensions.
  ft_disable = {},
  plugin_manager_path = vim.fn.stdpath("data") .. "/site/pack/packer",
  server_opts_overrides = {},
}


