-- vim.o.completeopt    = { 'menuone', 'noselect' }
vim.o.cindent        = true
vim.o.clipboard      = 'unnamedplus'
vim.o.cmdheight      = 2
vim.o.colorcolumn    = "80,120"
vim.o.conceallevel   = 0
vim.o.expandtab      = true
vim.o.hlsearch       = true
vim.o.ignorecase     = true
vim.o.number         = true
vim.o.numberwidth    = 4
vim.o.pumheight      = 10
vim.o.relativenumber = true
vim.o.scrolloff      = 8
vim.o.shiftwidth     = 2
vim.o.showtabline    = 0
vim.o.sidescrolloff  = 8
vim.o.signcolumn     = "yes"
vim.o.smartcase      = true
vim.o.softtabstop    = 2
vim.o.spelllang      = "en_us"
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.swapfile       = false
vim.o.tabstop        = 2
vim.o.termguicolors  = true
vim.o.timeoutlen     = 250
vim.o.undofile       = true
vim.o.updatetime     = 300
vim.o.wrap           = false
vim.o.writebackup    = false
vim.o.showbreak      = '^~>'


-- local function get_win_with_buf(bufnr)
--   vim.api.nvim_buf_call(bufnr, function()
--     return vim.api.nvim_win_get_number(0)
--   end)
-- end


-- local WhitespaceMode = {
-- 	toggled_buffers = {
-- 		number = 0,
-- 		original_syntax = "lua"
-- 	},

-- 	autocmd_ids = {},

-- 	enable_whitespace = function(bufnr)
-- 		
-- 	end

-- 	disable_whitespace = function(bufnr)

-- 	end
-- }

-- local function show_whitespace(bool)
-- 	if bool then
-- 		
-- 	end
-- end


-- local wrapped = {}

-- vim.api.nvim_create_autocmd({ 'OptionSet' }, {
--   pattern = { 'wrap' },
--   callback = function(opts)
--     local buffer = opts.buf
--
--     local window = vim.api.nvim_buf_call(buffer, function()
--       vim.api.nvim_win_get_number(0)
--     end)
--
--     local new_wrap_state = vim.api.nvim_get_option_value('wrap', { win = window } )
--     local colorcolumn = vim.api.nvim_get_option_value('colorcolumn', { win = window } )
--
--     if new_wrap_state then
--       table.insert(wrapped, {
--         colorcolumn = colorcolumn ,
--         buffer = buffer,
--         window = window
--       })
--
--       vim.api.nvim_set_option_value('colorcolumn', '', {
--         win = window
--       })
--
--       vim.api.nvim_set_option_value('colorcolumn', '', {
--         buf = buffer
--       })
--     else
--       local replacement_table = {}
--
--       for i, entry in ipairs(wrapped) do
--         if entry.buffer == buffer then
--           local new_window = vim.api.nvim_buf_call(entry.buffer, function()
--             vim.api.nvim_win_get_number(0)
--           end)
--
--           vim.api.nvim_set_option_value('colorcolumn', entry.colorcolumn, {
--             win = new_window
--           })
--         else
--           table.insert(replacement_table, entry)
--         end
--       end
--
--       wrapped = replacement_table
--       vim.notify(vim.inspect(wrapped))
--     end
--   end
-- })

vim.cmd('colorscheme retrobox')
