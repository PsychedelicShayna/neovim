MapKey { key = "<leader>ms",  does = "<cmd>lua require('navimark.stack').bookmark_toggle()<cr>", modes = "n", desc = "Toggle NaviMark" }
MapKey { key = "<leader>ma",  does = "<cmd>lua require('navimark.stack').bookmark_add()<cr>", modes = "n", desc = "Add NaviMark" }
MapKey { key = "<leader>md",  does = "<cmd>lua require('navimark.stack').bookmark_remove()<cr>", modes = "n", desc = "Delete NaviMark" }
MapKey { key = "<leader>jjm", does = "<cmd>lua require('navimark.stack').goto_next_mark()<cr>", modes = "n", desc = "Next NaviMark" }
MapKey { key = "<leader>jkm", does = "<cmd>lua require('navimark.stack').goto_prev_mark()<cr>", modes = "n", desc = "Prev NaviMark" }
MapKey { key = "<leader>mf",  does = "<cmd>lua require('navimark.tele').open_bookmark_picker()<cr>", modes = "n", desc = "Open NaviMark Menu" }
