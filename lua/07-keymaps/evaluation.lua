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
MapKey { key = '<M-;><M-L>', does = ':luafile%<cr>', modes = 'n', desc = "Lua File -> LuaJIT" }
MapKey { key = '<M-;><M-l>', does = '"+y:lua <C-r>+<cr>', modes = 'v', desc = "Lua Expression -> LuaJIT" }
MapKey { key = '<M-;><M-l>', does = 'V"+y:lua <C-r>+<cr>', modes = 'n', desc = "Lua Expression -> LuaJIT" }

-- Ex
MapKey { key = '<M-;><M-;>', does = '"my<esc>:<C-r>m<cr>', modes = 'v', desc = "Command -> :" }
MapKey { key = '<M-;><M-;>', does = 'V"my<esc>:<C-r>m<cr>', modes = 'n', desc = "Command -> :" }

-- Fish
MapKey { key = '<M-;><M-f>', does = '!fish <cr>', modes = 'v', desc = "Fish Expression -> Fish" }
MapKey { key = '<M-;><M-f>', does = 'V!fish <cr>', modes = 'n', desc = "Fish Expression -> Fish" }

-- Bash/Sh
MapKey { key = '<M-;><M-s>', does = '!bash <cr>', modes = 'v', desc = "Bash Expr -> Bash" }
MapKey { key = '<M-;><M-s>', does = 'V!bash <cr>', modes = 'n', desc = "Bash Expr -> Bash" }

-- Python
MapKey { key = '<M-;><M-p>', does = '!python - <cr>', modes = 'v', desc = "Python Code -> Interpreter" }
MapKey { key = '<M-;><M-p>', does = 'V!python - <cr>', modes = 'n', desc = "Python Code -> Interpreter" }
MapKey { key = '<M-;><M-q>', does = "ymmpV:'<,'>!qpe \'<C-r>+\'<cr>`m", modes = 'v', desc = "Python Expression -> QPE" }
MapKey { key = '<M-;><M-q>', does = 'mmyypV:!qpe \'<C-r>+\'<cr>`m', modes = 'n', desc = "Python Expression -> QPE" }
MapKey { key = '<M-;><M-P>', does = ":!python % <cr>", modes = 'n', desc = "Python File -> Interpreter" }

-- C++
MapKey { key = '<M-;><M-c>', does = '!xargs -0 --replace={} root -l -q -e \'{}\' 2>/dev/null | /usr/bin/cat<cr>', modes = 'v', desc = "C++ -> Root" }
MapKey { key = '<M-;><M-c>', does = 'V!xargs -0 --replace={} root -l -q -e \'{}\' 2>/dev/null | /usr/bin/cat<cr>', modes = 'n', desc = "C++ -> Root" }

-- Haskell
MapKey { key = '<M-;><M-g>', does = '!ghci -v0<cr>', modes = 'v', desc = "Haskell -> GHCi" }
MapKey { key = '<M-;><M-g>', does = 'V!ghci -v0<cr>', modes = 'n', desc = "Haskell -> GHCi" }

-- Rust
MapKey { key = '<M-;><M-r>', does = '!irust<cr>', modes = 'v', desc = "Rust -> iRust" }
MapKey { key = '<M-;><M-r>', does = 'V!irust<cr>', modes = 'n', desc = "Rust -> iRust" }

-- Base64 ---------------------------------------------------------------------
MapKey { key = '<M-;><M-b>', does = '!base64 <cr>', modes = 'v', desc = "Encode to base64 (ml)" }
MapKey { key = '<M-;><M-B>', does = '!base64 -d 2>&1<cr>', modes = 'v', desc = "Decode from base64 (ml)" }
MapKey { key = '<M-;><M-b>', does = 'V!base64 <cr>', modes = 'n', desc = "Encode to base64" }
MapKey { key = '<M-;><M-B>', does = 'V!base64 -d 2>&1<cr>', modes = 'n', desc = "Decode from base64" }

-- Working with binary data through xxd and other tools
-------------------------------------------------------------------------------
wk_chord_grouping:add_multi {
  { "<M-;><M-x>", group = "[XXD Dumping]", mode = { "v", "n" } }
}

MapKey { key = '<M-;><M-x><M-d>', does = '!xxd <cr>', modes = 'v', desc = "Hexdump (Standard)" }
MapKey { key = '<M-;><M-x><M-d>', does = 'V!xxd <cr>', modes = 'n', desc = "Hexdump (Standard)" }
MapKey { key = '<M-;><M-x><M-D>', does = '!xxd -r <cr>', modes = 'v', desc = "Reverse Hexdump (Standard)" }
MapKey { key = '<M-;><M-x><M-D>', does = 'V!xxd -r <cr>', modes = 'n', desc = "Reverse Hexdump (Standard)" }

MapKey { key = '<M-;><M-x><M-a>', does = '!xxd -a<cr>', modes = 'v', desc = "Hexdump (Autoskip Nulls)" }
MapKey { key = '<M-;><M-x><M-a>', does = 'V!xxd -a<cr>', modes = 'n', desc = "Hexdump (Autoskip Nulls)" }

MapKey { key = '<M-;><M-x><M-e>', does = '!xxd -e -g 2<cr>', modes = 'v', desc = "Hexdump (Inverted Endian)" }
MapKey { key = '<M-;><M-x><M-e>', does = 'V!xxd -e -g 2<cr>', modes = 'n', desc = "Hexdump (Inverted Endian)" }

MapKey { key = '<M-;><M-x><M-r>', does = '!xxd -c 0 -ps<cr>', modes = 'v', desc = "Hexdump (Raw)" }
MapKey { key = '<M-;><M-x><M-r>', does = 'V!xxd -c 0 -ps<cr>', modes = 'n', desc = "Hexdump (Raw)" }
MapKey { key = '<M-;><M-x><M-R>', does = '!xxd -ps -r<cr>', modes = 'v', desc = "Reverse Hexdump (Raw)" }
MapKey { key = '<M-;><M-x><M-R>', does = 'V!xxd -ps -r<cr>', modes = 'n', desc = "Reverse Hexdump (Raw)" }
MapKey { key = '<M-;><M-x><M-w>', does = '!xxd -ps<cr>', modes = 'v', desc = "Hexdump Wrapped (Raw)" }
MapKey { key = '<M-;><M-x><M-w>', does = 'V!xxd -ps<cr>', modes = 'n', desc = "Hexdump Wrapped (Raw)" }

MapKey { key = '<M-;><M-x><M-c>', does = '!xxd -i -n bytes<cr>', modes = 'v', desc = "Generate char[] Array" }
MapKey { key = '<M-;><M-x><M-c>', does = 'V!xxd -i -n bytes<cr>', modes = 'n', desc = "Generate char[] Array" }

MapKey { key = '<M-;><M-x><M-b>', does = '!xxd -b<cr>', modes = 'v', desc = "Binary Dump" }
MapKey { key = '<M-;><M-x><M-b>', does = 'V!xxd -b<cr>', modes = 'n', desc = "Binary Dump" }



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
  { "<a-;><M-h>",      group = "[Hashing]",     mode = { "v", "n" } },
  { "<a-;><M-h><M-s>", group = "[Sha2 Family]", mode = { "v", "n" } },
  { "<M-;><M-h><M-m>", group = "[MD Family]",   mode = { "v", "n" } },
  { "<a-;><M-h><M-x>", group = "[Xxh3 Family]", mode = { "v", "n" } }
}

-- SHA Family -----------------------------------------------------------------
MapKey { key = '<M-;><M-h><M-s><M-g>', does = '!sha1sum<cr>', modes = 'v', desc = "sha1" }
MapKey { key = '<M-;><M-h><M-s><M-g>', does = 'V!sha1sum<cr>', modes = 'n', desc = "sha1" }
MapKey { key = '<M-;><M-h><M-s><M-j>', does = '!sha224sum<cr>', modes = 'v', desc = "sha224sum" }
MapKey { key = '<M-;><M-h><M-s><M-j>', does = 'V!sha224sum<cr>', modes = 'n', desc = "sha224sum" }
MapKey { key = '<M-;><M-h><M-s><M-s>', does = '!sha256sum<cr>', modes = 'v', desc = "sha256sum" }
MapKey { key = '<M-;><M-h><M-s><M-s>', does = 'V!sha256sum<cr>', modes = 'n', desc = "sha256sum" }
MapKey { key = '<M-;><M-h><M-s><M-k>', does = '!sha384sum<cr>', modes = 'v', desc = "sha384sum" }
MapKey { key = '<M-;><M-h><M-s><M-k>', does = 'V!sha384sum<cr>', modes = 'n', desc = "sha384sum" }
MapKey { key = '<M-;><M-h><M-s><M-l>', does = '!sha512sum<cr>', modes = 'v', desc = "sha512sum" }
MapKey { key = '<M-;><M-h><M-s><M-l>', does = 'V!sha512sum<cr>', modes = 'n', desc = "sha512sum" }

-- XXH Family -----------------------------------------------------------------
MapKey { key = '<M-;><M-h><M-x><M-x>', does = '!xxhsum<cr>', modes = 'v', desc = "xxhsum(64)" }
MapKey { key = '<M-;><M-h><M-x><M-x>', does = 'V!xxhsum<cr>', modes = 'n', desc = "xxhsum(64)" }
MapKey { key = '<M-;><M-h><M-x><M-j>', does = '!xxh32sum<cr>', modes = 'v', desc = "xxh32sum" }
MapKey { key = '<M-;><M-h><M-x><M-j>', does = 'V!xxh32sum<cr>', modes = 'n', desc = "xxh32sum" }
MapKey { key = '<M-;><M-h><M-x><M-k>', does = '!xxh64sum<cr>', modes = 'v', desc = "xxh64sum" }
MapKey { key = '<M-;><M-h><M-x><M-k>', does = 'V!xxh64sum<cr>', modes = 'n', desc = "xxh64sum" }
MapKey { key = '<M-;><M-h><M-x><M-l>', does = '!xxh128sum<cr>', modes = 'v', desc = "xxh128sum" }
MapKey { key = '<M-;><M-h><M-x><M-l>', does = 'V!xxh128sum<cr>', modes = 'n', desc = "xxh128sum" }

-- MD Family ------------------------------------------------------------------
MapKey { key = '<M-;><M-h><M-m><M-m>', does = '!md5sum<cr>', modes = 'v', desc = "md5sum" }
MapKey { key = '<M-;><M-h><M-m><M-m>', does = 'V!md5sum<cr>', modes = 'n', desc = "md5sum" }
MapKey { key = '<M-;><M-h><M-m><M-h>', does = '!md4sum<cr>', modes = 'v', desc = "md4sum" }
MapKey { key = '<M-;><M-h><M-m><M-h>', does = 'V!md4sum<cr>', modes = 'n', desc = "md4sum" }

-- CRC Family -----------------------------------------------------------------
MapKey { key = '<M-;><M-h>cc', does = '<C-o>V!crc32sum<cr>', modes = 'i' }

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
