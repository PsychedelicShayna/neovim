-- This file determines the load order of the rest of the module folders.

local load_order = {
  "01-prelude",
  "02-storage",
  "03-native",
  "04-custom",
  "05-plugins",
  "06-lspconf",
  "07-keymaps"
}

require "01-prelude.events"
UsrLib = {}

for i, module_name in ipairs(load_order) do
  if type(module_name) == "string" then
    local module_ok, module = pcall(require, module_name)

    if not module_ok then
      vim.notify("Failed to load config stage #: " .. i, LL_ERROR)
      vim.notify("Stage module name, type, index, and resulting value: " ..
        module_name .. ", " .. type(module) .. ", " .. i .. ", " .. vim.inspect(module))
    end
  else
    vim.notify("Failed to load config stage #: " .. i, LL_ERROR)
    vim.notify("Stage module name, type, index, and resulting value: " ..
      module_name .. ", " .. type(module) .. ", " .. i .. ", " .. vim.inspect(module))
  end
end
