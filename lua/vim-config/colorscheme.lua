local colorscheme = "tokyonight"

-- Don't crash the entire config if the colorscheme doesn't exist.
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
