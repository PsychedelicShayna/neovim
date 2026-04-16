MapKey { key = "<leader>mm", does = "<cmd>lua require('navimark.stack').mark_toggle()<cr>", modes = "n", desc = "Toggle NaviMark" }
MapKey { key = "<leader>ma", does = "<cmd>lua require('navimark.stack').mark_add()<cr>", modes = "n", desc = "Add NaviMark" }
MapKey { key = "<leader>md", does = "<cmd>lua require('navimark.stack').mark_remove()<cr>", modes = "n", desc = "Delete NaviMark" }
-- MapKey { key = "gmn", does = "<cmd>lua require('navimark.stack').goto_next_mark()<cr>", modes = "n", desc = "Next NaviMark" }
-- MapKey { key = "gmp", does = "<cmd>lua require('navimark.stack').goto_prev_mark()<cr>", modes = "n", desc = "Prev NaviMark" }
MapKey { key = "<leader>fm", does = "<cmd>lua require('navimark.tele').open_mark_picker()<cr>", modes = "n", desc = "Find NaviMark" }
MapKey { key = "<leader>mt", does = "<cmd>lua require('navimark.stack').mark_add_with_title()<cr>", modes = "n", desc = "Add Titled NaviMark" }
