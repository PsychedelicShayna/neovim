-- vim.o.completeopt    = { 'menuone', 'noselect' }
vim.o.cindent        = true
vim.o.clipboard      = 'unnamedplus'
vim.o.cmdheight      = 2
vim.o.colorcolumn    = "80,120"
vim.o.conceallevel   = 0
vim.o.expandtab      = true
vim.o.hlsearch       = true
vim.o.ignorecase     = true
-- vim.o.nobuflisted    = true
vim.o.number         = true
vim.o.numberwidth    = 4
vim.o.pumheight      = 10
vim.o.relativenumber = true
vim.o.virtualedit    = "none"
vim.o.scrolloff      = 8
vim.o.shiftwidth     = 2
vim.o.showtabline    = 0
vim.o.sidescrolloff  = 8
vim.o.signcolumn     = "yes"
vim.o.showmatch      = true
vim.o.matchtime      = 1
vim.o.showfulltag    = true
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
vim.o.showbreak      = '++' -- '↪ '
vim.o.laststatus     = 3
vim.o.winbar         = '%y %t %m > %L > %l:%c > %b @ 0x%O (%o) > %F'
vim.o.shortmess      = "ltToOFIrC"
vim.o.showtabline    = 2

-- Set the leader key to space.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

-- vim.api.nvim_create_autocmd("VimEnter", {
--   once = true,
--   callback = function()
--     -- Set up a scratch buffer for the greeter
--     vim.cmd "enew"  -- equivalent to :new, opens an empty buffer
--     vim.bo.buftype = "nofile"
--     vim.bo.bufhidden = "wipe"
--     vim.bo.swapfile = false
--     vim.cmd "setlocal nobuflisted"
--
--     -- Put your ASCII art here (or load from a file)
--     local ascii_art = [[
--       ░█▀▀█ ░█▀▀█ ░█─── 
--       ░█▀▀▄ ░█─── ░█─── 
--       ░█▄▄█ ░█▄▄█ ░█▄▄█
--     ]]
--
--     local bufnr = vim.api.nvim_get_current_buf()
--    local lines = vim.split(ascii_art, "\n")
--    vim.notify(tostring(#lines))
--
--     -- Use extmarks to display the ASCII art as virtual text
--     local ns_id = vim.api.nvim_create_namespace("greeter")
--
--   -- • virt_text_win_col : position the virtual text at a fixed
--   --   window column (starting from the first text column of the
--   --   screen line) instead of "virt_text_pos".
--     for i, line in ipairs(lines) do
--       vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
--         virt_text = {{ line, "Comment" }},  -- You can choose a different highlight group
--         virt_text_pos = "overlay",           -- Centers the virtual text
--         -- virt_text_win_col = 50,
--         strict = false
--       })
--     end
--
--     -- Hide the greeter once you interact with the buffer
--     vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI", "ModeChanged", "BufNew", "BufEnter"}, {
--       once = true,
--       callback = function()
--         vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
--       end
--     })
--   end
-- })
-- vim.cmd('colorscheme murphy')
return true
