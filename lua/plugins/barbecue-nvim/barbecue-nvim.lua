local barbecue_ok, barbecue = pcall(require, "barbecue")
if not barbecue_ok then
  vim.notify("Ignored barbecue-nvim.lua because barbecue could not be imported.")
  return
end

vim.opt.updatetime = 200

-- vim.api.nvim_create_autocmd({
--   "WinScrolled",
--   "BufWinEnter",
--   "CursorHold",
--   "InsertLeave",
--
--   -- include these if you have set `show_modified` to `true`
--   -- "BufWritePost",
--   -- "TextChanged",
--   -- "TextChangedI",
-- }, {
--   group = vim.api.nvim_create_augroup("barbecue#create_autocmd", {}),
--   callback = function()
--     barbecue.ui.update()
--   end,
-- })

barbecue.setup {
  create_autocmd = true, -- prevent barbecue from updating itself automatically
}

vim.notify("Loaded barbecue")
