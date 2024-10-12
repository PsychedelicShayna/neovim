-------------------------------------------------------------------------------
-- Panes: Navigate, Resize, Delete
-------------------------------------------------------------------------------

-- Easily navigate between panes with Alt-hjkl, rather than Ctrl+w hjkl, same
-- for terminal. Seriously, C+\ C+Shift+n C+w h, to switch to the left pane
-- in terminal mode? What is this, Emacs? How about... Alt-h. Much better.

MapKey { key = '<A-h>', does = '<C-\\><C-N><C-w>h', modes = { 't', 'n' } }
MapKey { key = '<A-j>', does = '<C-\\><C-N><C-w>j', modes = { 't', 'n' } }
MapKey { key = '<A-k>', does = '<C-\\><C-N><C-w>k', modes = { 't', 'n' } }
MapKey { key = '<A-l>', does = '<C-\\><C-N><C-w>l', modes = { 't', 'n' } }


-- Resize the current pane relative to the others with Ctrl+hjkl
MapKey { key = '<C-h>', does = ':vertical resize -1<cr>' }
MapKey { key = '<C-j>', does = ':resize +1<cr>' }
MapKey { key = '<C-k>', does = ':resize -1<cr>' }
MapKey { key = '<C-l>', does = ':vertical resize +1<cr>' }

-- Close the current pane without deleting the buffer.
MapKey { key = '<A-c>', does = ':close!<cr>' }


-------------------------------------------------------------------------------
-- Buffers: Create, Navigate, Delete
-------------------------------------------------------------------------------

-- Creates a buffer and switches to it in the current pane.
MapKey { key = '<A-n>', does = ':ene<cr>', desc = "Create new buffer" }

-- Deletes the current buffer without closing the pane (vim-bbye plugin)
-- Reminder: look at the source code of bbye, and implement it yourself.
MapKey { key = '<A-d>', does = ':Bdelete!<cr>', desc = "Delete current buffer" }

-- Switch between buffers with Shift-h and Shift-l
MapKey { key = 'H', does = ':bprevious<cr>', desc = "Switch to previous buffer" }
MapKey { key = 'L', does = ':bnext<cr>', desc = "Switch to next buffer" }

-------------------------------------------------------------------------------
-- Tabs/Workspaces: Create, Navigate, Delete
-------------------------------------------------------------------------------

-- Same as buffers (Shift), just hold Alt+Shift for tabs.
MapKey { key = '<A-N>', does = ':tabnew<cr>', modes = 'n', desc = "Create new tab" }
MapKey { key = '<A-D>', does = ':tabclose<cr>', modes = 'n', desc = "Delete current tab" }
MapKey { key = '<A-H>', does = ':tabprevious<cr>', modes = 'n', desc = "Switch to previous tab" }
MapKey { key = '<A-L>', does = ':tabnext<cr>', modes = 'n', desc = "Switch to next tab" }

-------------------------------------------------------------------------------
-- Visual Mode Text Displacement
-------------------------------------------------------------------------------

-- Indent selected lines left or right without dropping into normal mode.
MapKey { key = '<', does = '<gv', modes = 'v', desc = "Unindent lines one level" }
MapKey { key = '>', does = '>gv', modes = 'v', desc = "Indent lines one level" }

-- Move selected lines up or down while staying in visual mode.
MapKey { key = 'K', does = ":move '<-2<cr>gv-gv", modes = 'v', desc = "Move lines up" }
MapKey { key = 'J', does = ":move '>+1<cr>gv-gv", modes = 'v', desc = "Move lines down" }


-------------------------------------------------------------------------------
-- Normal Mode Convenience

MapKey { key = '<A-w>', does = ':w<cr>', modes = 'n', desc = "Write File (:w)" }
MapKey { key = '<A-W>', does = ':w!<cr>', modes = 'n', desc = "!Write File (:w!)" }
MapKey { key = '<A-u>', does = '<C-r>', modes = 'n', desc = "Undo (<C-r>)" }
MapKey { key = '<A-r>', does = ':e!', modes = 'n', desc = "Reload file" }

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

-------------------------------------------------------------------------------
-- Insert Mode Convenience
-------------------------------------------------------------------------------

-- Undo and redo in insert mode.
MapKey { key = '<A-u>', does = '<C-o>u', modes = 'i' }
MapKey { key = '<A-U>', does = '<C-o>', modes = 'i' }


-- Move around in insert mode with Alt-hjkl
MapKey { key = '<A-h>', does = '<Left>', modes = 'i' }
-- l is under PUM bindings due binding conflicts.
MapKey { key = '<A-k>', does = '<Up>', modes = 'i' }
MapKey { key = '<A-j>', does = '<Down>', modes = 'i' }

-- Next/previous match.
MapKey { key = '<A-n>', does = '<C-o>n', modes = 'i' }
MapKey { key = '<A-N>', does = '<C-o>N', modes = 'i' }

-- Jump words, back words, end of word.
MapKey { key = '<A-w>', does = '<esc>lwi', modes = 'i' }
MapKey { key = '<A-e>', does = '<esc>llea', modes = 'i' }
MapKey { key = '<A-b>', does = '<esc>lbi', modes = 'i' }

-- Change wod in front or behind
MapKey { key = '<A-W>', does = '<esc>lcW', modes = 'i' }
MapKey { key = '<A-B>', does = '<esc>lcB', modes = 'i' }

-- Change inner word.
MapKey { key = '<A-a>', does = '<esc>lciw', modes = 'i' }

-- Run last @q macro.
MapKey { key = '<A-q>', does = '<esc>Qi', modes = 'i' }


-------------------------------------------------------------------------------
-- PUM (Popup Menu Bindings)
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('i', '<A-l>', [[pumvisible() ? "\<C-y>" : "\<C-e><Right>"]], { expr = true, silent = true })
vim.api.nvim_set_keymap('i', '<cr>', [[pumvisible() ? "\<C-e><cr>" : "\<cr>"]], { expr = true, silent = true })
