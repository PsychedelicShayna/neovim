
-- Allows navigation using h abd k while :set wrap is on.
-- vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true }) 

-- -- this needs to be tweaked a little for visual mode since it ends up doing line wis
-- vim.api.nvim_set_keymap("v", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
-- vim.api.nvim_set_keymap("v", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true }) 
