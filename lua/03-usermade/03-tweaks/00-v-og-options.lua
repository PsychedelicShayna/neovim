-- vim.o.completeopt    = { 'menuone', 'noselect' }
vim.o.cindent        = true
vim.o.clipboard      = 'unnamedplus'
vim.o.cmdheight      = 2
-- vim.o.colorcolumn    = "80,120"
vim.o.conceallevel   = 0
vim.o.hlsearch       = true
-- vim.o.nobuflisted    = true
vim.o.number         = true
vim.o.numberwidth    = 4
vim.o.pumheight      = 12
vim.o.relativenumber = true
vim.o.virtualedit    = "none"
vim.o.scrolloff      = 8
vim.o.showtabline    = 1
vim.o.sidescrolloff  = 8
vim.o.signcolumn     = "yes"

-- Briefly jumps to the matching brace/bracket/etc, when completing a pair.
-- Basically it's almost like the default matchparen plugin but less laggy.
-- matchtime=How long to linger at the match. The lower the better.
vim.o.showmatch      = true
vim.o.matchtime      = 1

-- Shows more info about matches when doing insert mode completion via Ctrl+n
vim.o.showfulltag    = true

-- Ignore+Smart Case will make any pattern matching case insensitive, unless
-- an uppercase character is deliberately put in the pattern.
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- Expands tabs into the approprite number of spaces.
vim.o.expandtab      = true
vim.o.shiftwidth     = 2  -- How many spaces per layer of indentation.
vim.o.softtabstop    = -1 -- How many spaces does one <tab> count for.
vim.o.tabstop        = 8  -- How many spaces does a <Tab> count for.

vim.o.spelllang      = "en_us"
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.swapfile       = false
vim.o.termguicolors  = true
vim.o.timeoutlen     = 250
vim.o.undofile       = true
vim.o.updatetime     = 300
vim.o.wrap           = false
vim.o.writebackup    = false
vim.o.laststatus     = 3

function global_cwd()
  return vim.fn.getcwd(-1, -1)
end

function win_local_cwd()
  return vim.fn.getcwd(vim.api.nvim_win_get_number(0))
end

vim.o.statusline  = "%{%v:lua.win_local_cwd()%}"

local function win_local_cwd()
  return vim.fn.getcwd(vim.api.nvim_win_get_number(0))
end



vim.o.winbar         = '%y %t %m > %L > %l:%c > %b  @ 0x%O (%o) > %F'
vim.o.shortmess      = "ltToOFIrC"

-- Set the leader key to space.
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- Don't draw color columns unless a file type has been set.
vim.api.nvim_create_autocmd("FileType", {
    once = true,
    callback = function()
        vim.o.colorcolumn = "80,120"
    end
})

-- local function get_win_with_buf(bufnr)
--   vim.api.nvim_buf_call(bufnr, function()
--     return vim.api.nvim_win_get_number(0)
--   end)
-- end


-- local WhitespaceMode = {
--      toggled_buffers = {
--              number = 0,
--              original_syntax = "lua"
--      },

--      autocmd_ids = {},

--      enable_whitespace = function(bufnr)
--              
--      end

--      disable_whitespace = function(bufnr)

--      end
-- }

-- local function show_whitespace(bool)
--      if bool then
--              
--      end
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

-- local function get_center(artw, arth, window)
--   -- fullscreen = 213
--   -- areee?? = 114 width
--   -- 99 = delta
--   -- 106.5
--
--   local win_width = vim.api.nvim_win_get_width(window)
--   local win_height = vim.api.nvim_win_get_height(window)
--
--   -- local center_col = math.floor((win_width - max_width) / 2)
--   local center_col = math.floor(math.floor(win_width / 2)) + artw
--   local center_row = math.floor((win_height ) / 2)
--
--   return center_col
-- end

return true
