if not vim.g.neovide then
  -- vim.notify("Neovide not found")
  return
end

-- vim.g.gui_font_default_size = 16
vim.g.gui_font_default_size = 14
vim.g.gui_font_size = vim.g.gui_font_default_size
-- vim.g.gui_font_face = "Hasklug NF"
-- vim.g.gui_font_face = "Consolas Ligaturized v3"
vim.g.gui_font_face = "Go Mono"

vim.g.neovide_cursor_vfx_mode = "wireframe"

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()


-- Keymaps

local opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'i' }, "<C-+>", function() ResizeGuiFont(1) end, opts)
vim.keymap.set({ 'n', 'i' }, "<C-->", function() ResizeGuiFont(-1) end, opts)