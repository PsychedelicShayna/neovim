local colorscheme = "onedark"

local disable_background = false

if(disable_background) then
  vim.cmd [[
    autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  ]]
end

-- Don't crash the entire config if the colorscheme doesn't exist.
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
