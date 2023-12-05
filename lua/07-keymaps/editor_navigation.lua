-- Panes
-------------------------------------------------------------------------------
--
-- Easily navigate between panes with Alt-hjkl, rather than Ctrl+w hjkl, same
-- for terminal. Seriously, C+\ C+Shift+n C+w h, to switch to the left pane
-- in terminal mode? What is this, Emacs? How about... Alt-h. Much better.

MapKey { key = '<A-h>', does = '<C-\\><C-N><C-w>h', modes = { 't', 'n' } }
MapKey { key = '<A-j>', does = '<C-\\><C-N><C-w>j', modes = { 't', 'n' } }
MapKey { key = '<A-k>', does = '<C-\\><C-N><C-w>k', modes = { 't', 'n' } }
MapKey { key = '<A-l>', does = '<C-\\><C-N><C-w>l', modes = { 't', 'n' } }

-- Resize the pane with Ctrl+{h,j,k,l}
MapKey { key = '<C-h>', does = ':vertical resize -1<cr>' }
MapKey { key = '<C-j>', does = ':resize +1<cr>' }
MapKey { key = '<C-k>', does = ':resize -1<cr>' }
MapKey { key = '<C-l>', does = ':vertical resize +1<cr>' }

MapKey { key = '<M-c>', does = ':close!<cr>' }

--
-------------------------------------------------------------------------------
-- Buffers
-------------------------------------------------------------------------------
--

-- Create a new buffer.
MapKey { key = '<M-n>', does = ':ene<cr>' }

-- Force delete the current buffer.
MapKey { key = '<M-d>', does = ':Bdelete!<cr>' }

-- Switch between buffers with Shift-hl
MapKey { key = '<S-h>', does = ':bprevious<cr>' }
MapKey { key = '<S-l>', does = ':bnext<cr>' }

--
-------------------------------------------------------------------------------
-- Tabs
-------------------------------------------------------------------------------
--

MapKey { key = '<A-N>', does = ':tabnew<cr>', modes = 'n' }
MapKey { key = '<A-C>', does = ':tabclose<cr>', modes = 'n' }
MapKey { key = '<A-L>', does = ':tabnext<cr>', modes = 'n' }
MapKey { key = '<A-H>', does = ':tabprevious<cr>', modes = 'n' }

--
-------------------------------------------------------------------------------
-- Text Displacement
-------------------------------------------------------------------------------
--

-- Indent in visual mode without getting kicked into normal mode.
MapKey { key = '<', does = '<gv', modes = 'v' }
MapKey { key = '>', does = '>gv', modes = 'v' }
MapKey { key = 'K', does = ":move '<-2<cr>gv-gv", modes = 'v' }
MapKey { key = 'J', does = ":move '>+1<cr>gv-gv", modes = 'v' }

--
-------------------------------------------------------------------------------
-- Insert Mode Convenience (Alt is best)
-------------------------------------------------------------------------------
--

-- Replace <C-o> with <Alt-;><Alt-;> to perform one normal mode action.
MapKey { key = '<A-;><A-;>', does = '<C-o>', modes = 'i' }

-- Write the file with Alt-; Alt-w
MapKey { key = '<A-;><A-w>', does = '<C-o>:w<cr>', modes = 'i' }
MapKey { key = '<A-;><A-W>', does = '<C-o>:w!<cr>', modes = 'i' }

-- Reload the file with Alt-; Alt-e
MapKey { key = '<A-;><A-e>', does = '<C-o>:e!<cr>', modes = 'i' }

-- Move around in insert mode with Alt-hjkl
MapKey { key = '<A-h>', does = '<Left>', modes = 'i' }
MapKey { key = '<A-l>', does = '<Right>', modes = 'i' }
MapKey { key = '<A-k>', does = '<Up>', modes = 'i' }
MapKey { key = '<A-j>', does = '<Down>', modes = 'i' }

-- Jump words with Alt-wbe
MapKey { key = '<A-w>', does = '<C-o>w', modes = 'i' }
MapKey { key = '<A-b>', does = '<C-o>b', modes = 'i' }
MapKey { key = '<A-e>', does = '<C-o>e', modes = 'i' }

-- Jump WORDS with Alt-WBE
MapKey { key = '<A-W>', does = '<C-o>W', modes = 'i' }
MapKey { key = '<A-B>', does = '<C-o>B', modes = 'i' }
MapKey { key = '<A-E>', does = '<C-o>E', modes = 'i' }

-- Perform change and deletes in insert mode with Alt-c and Alt-d
MapKey { key = '<A-c>', does = '<C-o>c', modes = 'i' }
MapKey { key = '<A-d>', does = '<C-o>d', modes = 'i' }

-- Find forward and backwards with <Alt-f> and <Alt-F>.
MapKey { key = '<A-f>', does = '<C-o>f', modes = 'i' }
MapKey { key = '<A-F>', does = '<C-o>F', modes = 'i' }

--
-------------------------------------------------------------------------------
-- Normal Mode Convenience (Alt is best)

MapKey { key = '<A-w>', does = ':w<cr>', modes = 'n' }
MapKey { key = '<A-W>', does = ':w!<cr>', modes = 'n' }
MapKey { key = '<A-u>', does = '<C-r>', modes = 'n' }


-- Evaluate the current line a number of different ways, through internal and
-- external command invocations. Visual mode has its own version as well.

MapKey { key = '<A-;><A-L>', does = ':luafile%<cr>', modes = 'n' }
MapKey { key = '<A-;><A-l>', does = 'V"+y:lua <C-r>+<cr>', modes = 'n' }
MapKey { key = '<A-;><A-;>', does = 'V"my<esc>:<C-r>m<cr>gv', modes = 'n' }

MapKey { key = '<A-;><A-s>', does = 'V!fish <cr>', modes = 'n' }
MapKey { key = '<A-;><A-x>', does = 'V!xxd <cr>', modes = 'n' }
MapKey { key = '<A-;><A-X>', does = 'V!xxd -r <cr>', modes = 'n' }

MapKey { key = '<A-;><A-b>', does = 'V!base64<cr>', modes = 'n' }
MapKey { key = '<A-;><A-B>', does = 'V!base64 -d<cr>', modes = 'n' }

MapKey { key = '<A-;><A-h>m5', does = 'V!sha512sum<cr>', modes = 'n' }
MapKey { key = '<A-;><A-h>s1', does = 'V!sha1sum<cr>', modes = 'n' }
MapKey { key = '<A-;><A-h>s24', does = 'V!sha224sum<cr>', modes = 'n' }
MapKey { key = '<A-;><A-h>s25', does = 'V!sha256sum<cr>', modes = 'n' }
MapKey { key = '<A-;><A-h>s38', does = 'V!sha384sum<cr>', modes = 'n' }
MapKey { key = '<A-;><A-h>s51', does = 'V!sha512sum<cr>', modes = 'n' }

MapKey { key = '<A-;><A-p>', does = 'V!python - <cr>', modes = 'n' }
MapKey { key = '<A-;><A-q>', does = 'yyV:!qpe \'<C-r>+\'<cr>', modes = 'n' }

--
--
-------------------------------------------------------------------------------
-- Visual Mode Convenience (Alt is best)
--

MapKey { key = '<A-;><A-L>', does = ':luafile%<cr>', modes = 'v' }
MapKey { key = '<A-;><A-l>', does = '"+y:lua <C-r>+<cr>', modes = 'v' }

MapKey { key = '<A-;><A-;>', does = '"my<esc>:<C-r>m<cr>gv', modes = 'v' }
MapKey { key = '<A-;><A-s>', does = '!fish <cr>', modes = 'v' }
MapKey { key = '<A-;><A-x>', does = '!xxd <cr>', modes = 'v' }
MapKey { key = '<A-;><A-X>', does = '!xxd -r <cr>', modes = 'v' }
MapKey { key = '<A-;><A-b>', does = '!base64 <cr>', modes = 'v' }
MapKey { key = '<A-;><A-B>', does = '!base64 -d 2>&1<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>m5', does = '!sha512sum<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>s1', does = '!sha1sum<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>s24', does = '!sha224sum<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>s25', does = '!sha256sum<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>s38', does = '!sha384sum<cr>', modes = 'v' }
MapKey { key = '<A-;><A-h>s51', does = '!sha512sum<cr>', modes = 'v' }

MapKey { key = '<A-;><A-p>', does = '!python - <cr>', modes = 'v' }
MapKey { key = '<A-;><A-q>', does = 'y:!qpe \'<C-r>+\'<cr>', modes = 'v' }

-- Allow Alt-vbl to cycle through visual, visual-line and visual-block
-- without leaving visual mode when hitting it twice. Also, allow for
-- the traditional convert to block/visual behavior by holidng shift.
-- Hitting Alt-v in normal mode is the same as gv, making everything
-- quick and nearby.
MapKey { key = '<A-v>', does = 'gv', modes = 'n' }
MapKey { key = '<A-v>', does = '<esc>gvvvgv', modes = 'v' }
MapKey { key = '<A-b>', does = '<esc>`<<C-v>`>', modes = 'v' }
MapKey { key = '<A-B>', does = '<C-v>', modes = 'v' }
MapKey { key = '<A-l>', does = '<esc>`<V`>', modes = 'v' }
MapKey { key = '<A-L>', does = 'V', modes = 'v' }

--
-------------------------------------------------------------------------------
