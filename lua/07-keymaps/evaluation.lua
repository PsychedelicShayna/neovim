-- Will later be passed onto which-key to assign names to key sequeces/chords
-- that can go in several different directions.
local wk_chord_grouping = { for_wk = {} }

function wk_chord_grouping:add_multi(groups)
  for _, group in ipairs(groups) do
    table.insert(self.for_wk, group)
  end
end

-- Defined to avoid confusion with add_multi.
function wk_chord_grouping:add(group)
  table.insert(self.for_wk, group)
end

-------------------------------------------------------------------------------
-- Expression Evaluation
-------------------------------------------------------------------------------

-- Lua
MapKey { key = '<A-;><A-L>', does = ':luafile%<cr>', modes = 'n', desc = "Eval whole file as Lua" }
MapKey { key = '<A-;><A-l>', does = '"+y:lua <C-r>+<cr>', modes = 'v', desc = "Eval as Lua (ml)" }
MapKey { key = '<A-;><A-l>', does = 'V"+y:lua <C-r>+<cr>', modes = 'n', desc = "Eval line as Lua" }

-- Ex
MapKey { key = '<A-;><A-;>', does = '"my<esc>:<C-r>m<cr>', modes = 'v', desc = "Eval as :ex command" }
MapKey { key = '<A-;><A-;>', does = 'V"my<esc>:<C-r>m<cr>', modes = 'n', desc = "Eval line as :ex command" }

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

-- Working with binary data through xxd and other tools
-------------------------------------------------------------------------------
wk_chord_grouping:add_multi {
  { "<A-;><A-x>", group = "[XXD Dumping]", mode = { "v", "n" } }
}

MapKey { key = '<A-;><A-x><A-d>', does = '!xxd <cr>', modes = 'v', desc = "Hexdump (Standard)" }
MapKey { key = '<A-;><A-x><A-d>', does = 'V!xxd <cr>', modes = 'n', desc = "Hexdump (Standard)" }
MapKey { key = '<A-;><A-x><A-D>', does = '!xxd -r <cr>', modes = 'v', desc = "Reverse Hexdump (Standard)" }
MapKey { key = '<A-;><A-x><A-D>', does = 'V!xxd -r <cr>', modes = 'n', desc = "Reverse Hexdump (Standard)" }

MapKey { key = '<A-;><A-x><A-a>', does = '!xxd -a<cr>', modes = 'v', desc = "Hexdump (Autoskip Nulls)" }
MapKey { key = '<A-;><A-x><A-a>', does = 'V!xxd -a<cr>', modes = 'n', desc = "Hexdump (Autoskip Nulls)" }

MapKey { key = '<A-;><A-x><A-e>', does = '!xxd -e -g 2<cr>', modes = 'v', desc = "Hexdump (Inverted Endian)" }
MapKey { key = '<A-;><A-x><A-e>', does = 'V!xxd -e -g 2<cr>', modes = 'n', desc = "Hexdump (Inverted Endian)" }

MapKey { key = '<A-;><A-x><A-r>', does = '!xxd -c 0 -ps<cr>', modes = 'v', desc = "Hexdump (Raw)" }
MapKey { key = '<A-;><A-x><A-r>', does = 'V!xxd -c 0 -ps<cr>', modes = 'n', desc = "Hexdump (Raw)" }
MapKey { key = '<A-;><A-x><A-R>', does = '!xxd -ps -r<cr>', modes = 'v', desc = "Reverse Hexdump (Raw)" }
MapKey { key = '<A-;><A-x><A-R>', does = 'V!xxd -ps -r<cr>', modes = 'n', desc = "Reverse Hexdump (Raw)" }
MapKey { key = '<A-;><A-x><A-w>', does = '!xxd -ps<cr>', modes = 'v', desc = "Hexdump Wrapped (Raw)" }
MapKey { key = '<A-;><A-x><A-w>', does = 'V!xxd -ps<cr>', modes = 'n', desc = "Hexdump Wrapped (Raw)" }

MapKey { key = '<A-;><A-x><A-c>', does = '!xxd -i -n bytes<cr>', modes = 'v', desc = "Generate char[] Array" }
MapKey { key = '<A-;><A-x><A-c>', does = 'V!xxd -i -n bytes<cr>', modes = 'n', desc = "Generate char[] Array" }

MapKey { key = '<A-;><A-x><A-b>', does = '!xxd -b<cr>', modes = 'v', desc = "Binary Dump" }
MapKey { key = '<A-;><A-x><A-b>', does = 'V!xxd -b<cr>', modes = 'n', desc = "Binary Dump" }



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

wk_chord_grouping:add_multi {
  { "<a-;><A-h>",      group = "[Hashing]",     mode = { "v", "n" } },
  { "<a-;><A-h><A-s>", group = "[Sha2 Family]", mode = { "v", "n" } },
  { "<A-;><A-h><A-m>", group = "[MD Family]",   mode = { "v", "n" } },
  { "<a-;><A-h><A-x>", group = "[Xxh3 Family]", mode = { "v", "n" } }
}

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
MapKey { key = '<A-;><A-h><A-m><A-m>', does = '!md5sum<cr>', modes = 'v', desc = "md5sum" }
MapKey { key = '<A-;><A-h><A-m><A-m>', does = 'V!md5sum<cr>', modes = 'n', desc = "md5sum" }
MapKey { key = '<A-;><A-h><A-m><A-h>', does = '!md4sum<cr>', modes = 'v', desc = "md4sum" }
MapKey { key = '<A-;><A-h><A-m><A-h>', does = 'V!md4sum<cr>', modes = 'n', desc = "md4sum" }

-- CRC Family -----------------------------------------------------------------
MapKey { key = '<A-;><A-h>cc', does = '<C-o>V!crc32sum<cr>', modes = 'i' }

Events.await_event {
  actor = "which-key",
  event = "configured",
  retroactive = true,
  callback = function()
    Safe.import_then('which-key', function(wk)
      wk.add(wk_chord_grouping.for_wk)
    end)
  end
}
