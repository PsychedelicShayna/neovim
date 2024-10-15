-- No seriously this config is not compatible with Windows. Disabling this is
-- not going to make it compatible. I'm not *just* doing a bit of trolling,
-- there are legitimate reasons. This config can and will crash often if it
-- will run at all on Windows.
--

if vim.fn.has("win32") == 1 then
  -- 12x68
  local we_do_a_little_trolling = {

    [[                                                             Windows                                   ]],
    [[                                                                                                       ]],
    [[                                   An error has occurred. To continue:                                 ]],
    [[                                                                                                       ]],
    [[                                   Press Enter to return to Windows, or                                ]],
    [[                                                                                                       ]],
    [[                                   Press CTRL+ALT+DEL to restart your computer. If you do this,        ]],
    [[                                   you may select a bootable Linux install USB upon entering the,      ]],
    [[                                   BIOS, and use the time to contemplate your poor life decisions.     ]],
    [[                                                                                                       ]],
    [[                                   Error: 2L : IQ4U : 2US3L1NUX                                        ]],
    [[                                                                                                       ]],
    [[                                                         Press any key to continue _                   ]]
  }
  vim.cmd("color blue")

  vim.o.termguicolors = true
  vim.o.shortmess = "I"

  vim.cmd(":hi Normal guibg=#0000AA guifg=#FFFFFF ctermbg=blue ctermfg=white")
  vim.cmd(":hi NormalFloat guibg=#0000AA guifg=#FFFFFF ctermbg=blue ctermfg=white")
  vim.cmd(":hi NormalNC guibg=#0000AA guifg=#FFFFFF ctermbg=blue ctermfg=white")
  vim.cmd(":hi EndOfBuffer guibg=#0000AA guifg=#FFFFFF ctermbg=blue ctermfg=white")
  vim.cmd(":hi NonText guibg=#0000AA guifg=#0000AA ctermbg=blue ctermfg=blue")
  -- vim.o.fillchars = "stlnc: ,stl: ,vert: ,fold: ,msgsep: ,eob: ,diff"

  local win_width = vim.api.nvim_win_get_width(0)
  local win_height = vim.api.nvim_win_get_height(0)

  local win_relative_center = math.floor((win_width - 68) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = win_width*2,
    height = win_height,
    col = win_width, -- 63 technicalllly
    row = win_height, -- 12 technically
    border = "none"
  })

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  -- lua =vim.api.nvim_get_hl(0, {name="Normal" })
  -- lua =vim.api.nvim_set_hl(0, "NormalFloat", {fg = "#ffffff"})

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].cursorline = false
  vim.wo[win].cursorcolumn = false
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].spell = false
  vim.wo[win].list = false
  vim.wo[win].signcolumn = "auto"
  vim.wo[win].colorcolumn = ""
  vim.wo[win].statuscolumn = ""

  vim.o.virtualedit="all"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, we_do_a_little_trolling)

  -- Recenter the float on window resize
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      -- Recalculate center position
      local new_win_width = vim.api.nvim_win_get_width(0)
      local new_win_height = vim.api.nvim_win_get_height(0)

      win_relative_center = math.floor((new_win_width - 68) / 2)
      -- local new_col = math.floor((new_win_width - 64) / 2)
      -- local new_row = math.floor((new_win_height - 13) / 2)

      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, {
          relative = "editor",
          width = new_win_width,
          height = new_win_height,
          col = win_relative_center,
          row = new_win_height,
        })

        vim.api.nvim_buf_set_lines(buf, 0, 21, false, we_do_a_little_trolling)
      end
    end
  })

else
  require("init")
end
