local trevj_ok, trevj = pcall(require, "trevj")

vim.api.nvim_set_keymap("n", "K",
  [[ <cmd>lua require("trevj").format_at_cursor()<cr> ]],
  { noremap = true, silent = true }
)



-- an example for configuring a keybind, can also be done by filetype
-- setup = function()
--   vim.keymap.set('n', '<leader>j', function()
--     require('trevj').format_at_cursor()
--   end)
-- end,


-- When configuring a language you should specify the treesitter node types that contains the child nodes which should be put on separate lines. For example for the default configuration for lua looks as follows:


