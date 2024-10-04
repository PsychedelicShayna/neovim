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
-- Normal Mode Convenience (Alt is best)

MapKey { key = '<A-w>', does = ':w<cr>', modes = 'n', desc = "Write File (:w)" }
MapKey { key = '<A-W>', does = ':w!<cr>', modes = 'n', desc = "!Write File (:w!)" }
MapKey { key = '<A-u>', does = '<C-r>', modes = 'n', desc = "Undo (<C-r>)" }

-- Expression Evaluation ------------------------------------------------------

-- Lua
MapKey { key = '<A-;><A-L>', does = ':luafile%<cr>', modes = 'n', desc = "Eval whole file as Lua" }
MapKey { key = '<A-;><A-l>', does = '"+y:lua <C-r>+<cr>', modes = 'v', desc = "Eval as Lua (ml)" }
MapKey { key = '<A-;><A-l>', does = 'V"+y:lua <C-r>+<cr>', modes = 'n', desc = "Eval line as Lua" }

-- Ex
MapKey { key = '<A-;><A-;>', does = '"my<esc>:<C-r>m<cr>', modes = 'v', desc = "Eval as :ex command" }
MapKey { key = '<A-;><A-;>', does = 'V"my<esc>:<C-r>m<cr>', modes = 'n', desc = "Eval line as :ex command" }

Events.await_event {
  actor = "which-key",
  event = "configured",
  retroactive = true,
  callback = function()
    Safe.import_then('which-key', function(wk)
      wk.add {
        { "<A-;><A-h>",      group = "[Hash With]",   mode = { "v", "n" } },
        { "<A-;><A-h><A-s>", group = "[SHA2 Family]", mode = { "v", "n" } },
        { "<A-;><A-h><A-m>", group = "[MD Family]",   mode = { "v", "n" } },
        { "<A-;><A-h><A-x>", group = "[XXH Family]",  mode = { "v", "n" } }
      }
    end)
  end
}

-- Fish
MapKey { key = '<A-;><A-s>', does = '!fish <cr>', modes = 'v', desc = "Eval as Fish expression and substitute (ml)" }
MapKey { key = '<A-;><A-s>', does = 'V!fish <cr>', modes = 'n', desc = "Eval as Fish expression and substitute" }

-- Python
MapKey { key = '<A-;><A-Y>', does = '!python - <cr>', modes = 'v', desc = "Eval as Python (ml)" }
MapKey { key = '<A-;><A-p>', does = 'V!python - <cr>', modes = 'n', desc = "Eval line as Python" }
MapKey { key = '<A-;><A-y>', does = "y:'<,'>!qpe \'<C-r>+\'<cr>", modes = 'v', desc = "Eval as Python via QPE" }
MapKey { key = '<A-;><A-q>', does = 'yyV:!qpe \'<C-r>+\'<cr>', modes = 'n', desc = "Eval line as Python via QPE" }

-- Base64 ---------------------------------------------------------------------
MapKey { key = '<A-;><A-b>', does = '!base64 <cr>', modes = 'v', desc = "Encode to base64 (ml)" }
MapKey { key = '<A-;><A-B>', does = '!base64 -d 2>&1<cr>', modes = 'v', desc = "Decode from base64 (ml)" }
MapKey { key = '<A-;><A-b>', does = 'V!base64 <cr>', modes = 'n', desc = "Encode to base64" }
MapKey { key = '<A-;><A-B>', does = 'V!base64 -d 2>&1<cr>', modes = 'n', desc = "Decode from base64" }

MapKey { key = '<A-;><A-h><A-m>m', does = '!md5sum<cr>', modes = 'v', desc = "md5" }

-- Hashing with Various Algorithms --------------------------------------------

-- I've put some thought behind the keystrokes for selecting algorithms.
--
-- 1.) The same key used to select the family is also the key to select the
--     default algorihm for that family, e.g. sha256 for the sha2 family.
--     Since your finger is already there from selecting the family, you
--     can just hit it again if you don't need a specific variant.
--
-- 2.) Variants are laid out close to the home row: h, j, k, l, etc, and are
--     sorted from left to right (weakest/shortest and or strongest/longest).
--     The longest will always be on l, and the shorter the algorithm, the
--     further to the left it goes, past h and onto g, f, d, s, a, etc.
--
-- 3.) Variants with quirks that don't make them inherently stronger or weaker
--     but are special in some different way, get moved up a row, and shifted
--     to the right by one: g, h, j, k, l becomes y, u, i, o, p, and so on.
--
-- Why shift it to the right? Ask your wrist.

-- Why keep holding Alt throughout the wole thing? Adding the cognitive load
-- of knowing when to let go slows you down. Alt+;hsh is much quicker.

-- SHA Family -----------------------------------------------------------------
MapKey { key = '<A-;><A-h><A-s><A-g>', does = '!sha1sum<cr>', modes = 'v', desc = "sha1" }
MapKey { key = '<A-;><A-h><A-s><A-g>', does = 'V!sha1sum<cr>', modes = 'n', desc = "sha1" }
MapKey { key = '<A-;><A-h><A-s><A-j>', does = '!sha224sum<cr>', modes = 'v', desc = "sha224sum" }
MapKey { key = '<A-;><A-h><A-s><A-j>', does = 'V!sha224sum<cr>', modes = 'n', desc = "sha224sum" }
MapKey { key = '<A-;><A-h><A-s><A-s>', does = '!sha256sum<cr>', modes = 'v', desc = "sha256sum" }
MapKey { key = '<A-;><A-h><A-s><A-s>', does = 'V!sha256sum<cr>', modes = 'n', desc = "sha256sum" }
MapKey { key = '<A-;><A-h><A-s><A-k>', does = '!sha384sum<cr>', modes = 'v', desc = "sha384sum" }
MapKey { key = '<A-;><A-h><A-s><A-k>', does = 'V!sha384sum<cr>', modes = 'n', desc = "sha384sum" }
MapKey { key = '<A-;><A-h><A-s><A-l>', does = '!sha512sum<cr>', modes = 'v', desc = "sha512sum" }
MapKey { key = '<A-;><A-h><A-s><A-l>', does = 'V!sha512sum<cr>', modes = 'n', desc = "sha512sum" }

-- XXH Family -----------------------------------------------------------------
MapKey { key = '<A-;><A-h><A-x><A-x>', does = '!xxhsum<cr>', modes = 'v', desc = "xxhsum(64)" }
MapKey { key = '<A-;><A-h><A-x><A-x>', does = 'V!xxhsum<cr>', modes = 'n', desc = "xxhsum(64)" }
MapKey { key = '<A-;><A-h><A-x><A-j>', does = '!xxh32sum<cr>', modes = 'v', desc = "xxh32sum" }
MapKey { key = '<A-;><A-h><A-x><A-j>', does = 'V!xxh32sum<cr>', modes = 'n', desc = "xxh32sum" }
MapKey { key = '<A-;><A-h><A-x><A-k>', does = '!xxh64sum<cr>', modes = 'v', desc = "xxh64sum" }
MapKey { key = '<A-;><A-h><A-x><A-k>', does = 'V!xxh64sum<cr>', modes = 'n', desc = "xxh64sum" }
MapKey { key = '<A-;><A-h><A-x><A-l>', does = '!xxh128sum<cr>', modes = 'v', desc = "xxh128sum" }
MapKey { key = '<A-;><A-h><A-x><A-l>', does = 'V!xxh128sum<cr>', modes = 'n', desc = "xxh128sum" }

-- MD Family ------------------------------------------------------------------
MapKey { key = '<A-;><A-h><A-m><A-m>', does = '<C-o>V!md5sum<cr>', modes = 'i' }

-- CRC Family -----------------------------------------------------------------
MapKey { key = '<A-;><A-h>cc', does = '<C-o>V!crc32sum<cr>', modes = 'i' }

Events.await_event {
  actor = "which-key",
  event = "configured",
  retroactive = true,
  callback = function()
    Safe.import_then('which-key', function(wk)
      wk.add {
        { "<A-;><A-h>",      group = "[Hash With]",   mode = { "v", "n" } },
        { "<A-;><A-h><A-s>", group = "[SHA2 Family]", mode = { "v", "n" } },
        { "<A-;><A-h><A-m>", group = "[MD Family]",   mode = { "v", "n" } },
        { "<A-;><A-h><A-x>", group = "[XXH Family]",  mode = { "v", "n" } }
      }
    end)
  end
}

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
