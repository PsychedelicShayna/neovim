-- Displays a randomly selected cat on a fence upon starting Neovim with no
-- file given or no input from stdin. Disappears the moment you interact.
local fence_cats = {
  { -- cat 1
    [[           *     ,MMM8&&&.            *   ]],
    [[                MMMM88&&&&&    .          ]],
    [[               MMMM88&&&&&&&              ]],
    [[   *           MMM88&&&&&&&&              ]],
    [[               MMM88&&&&&&&&              ]],
    [[               'MMM88&&&&&&'              ]],
    [[                 'MMM8&&&'      *         ]],
    [[        |\___/|                           ]],
    [[        )     (             .             ]],
    [[       =\     /=                          ]],
    [[         )===(       *                    ]],
    [[        /     \                           ]],
    [[        |     |                           ]],
    [[       /       \                          ]],
    [[       \       /                          ]],
    [[_/\_/\_/\__  _/_/\_/\_/\_/\_/\_/\_/\_/\_/\]],
    [[|  |  |  |( (  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  | ) ) |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |(_(  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
  },
  { -- cat 2
    [[           *     ,MMM8&&&.            *   ]],
    [[                MMMM88&&&&&    .          ]],
    [[               MMMM88&&&&&&&              ]],
    [[   *           MMM88&&&&&&&&              ]],
    [[               MMM88&&&&&&&&              ]],
    [[               'MMM88&&&&&&'              ]],
    [[                 'MMM8&&&'      *    _    ]],
    [[        |\___/|                      \\   ]],
    [[       =) ^Y^ (=   |\_/|              ||  ]],
    [[        \  ^  /    )a a '._.-""""-.  //   ]],
    [[         )=*=(    =\T_= /    ~  ~  \//    ]],
    [[        /     \     `"`\   ~   / ~  /     ]],
    [[        |     |         |~   \ |  ~/      ]],
    [[       /| | | |\         \  ~/- \ ~\      ]],
    [[       \| | |_|/|        || |  // /`      ]],
    [[_/\_/\_//_// __//\_/\_/\_((_|\((_//\_/\_/\]],
    [[|  |  |  | \_) |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
  },
  { -- cat 3
    [[          *      ,MMM8&&&.           *    ]],
    [[                MMMM88&&&&&    .          ]],
    [[               MMMM88&&&&&&&              ]],
    [[   *           MMM88&&&&&&&&              ]],
    [[               MMM88&&&&&&&&              ]],
    [[               'MMM88&&&&&&'              ]],
    [[                 'MMM8&&&'      *         ]],
    [[        |\___/|     /\___/\               ]],
    [[        )     (     )    ~( .             ]],
    [[       =\     /=   =\~    /=              ]],
    [[         )===(       ) ~ (                ]],
    [[        /     \     /     \               ]],
    [[        |     |     ) ~   (               ]],
    [[       /       \   /     ~ \              ]],
    [[       \       /   \~     ~/              ]],
    [[_/\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\]],
    [[|  |  |  |( (  |  |  | ))  |  |  |  |  |  ]],
    [[|  |  |  | ) ) |  |  |//|  |  |  |  |  |  ]],
    [[|  |  |  |(_(  |  |  (( |  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |\)|  |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
  },
  { -- cat4
    [[           *     ,MMM8&&&.             *  ]],
    [[                MMMM88&&&&&    .          ]],
    [[               MMMM88&&&&&&&              ]],
    [[   *           MMM88&&&&&&&&              ]],
    [[               MMM88&&&&&&&&              ]],
    [[               'MMM88&&&&&&'              ]],
    [[                 'MMM8&&&'      *         ]],
    [[         /\/|_      __/\\                 ]],
    [[        /    -\    /-   ~\  .             ]],
    [[        \    = Y =T_ =   /                ]],
    [[         )==*(`     `) ~ \                ]],
    [[        /     \     /     \               ]],
    [[        |     |     ) ~   (               ]],
    [[       /       \   /     ~ \              ]],
    [[       \       /   \~     ~/              ]],
    [[_/\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\]],
    [[|  |  |  | ) ) |  |  | ((  |  |  |  |  |  ]],
    [[|  |  |  |( (  |  |  |  \\ |  |  |  |  |  ]],
    [[|  |  |  | )_) |  |  |  |))|  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  (/ |  |  |  |  |  ]],
    [[|  |  |  |  |  |  |  |  |  |  |  |  |  |  ]],
  }
}

---@param strings table An array of strings.
---@return number The length of the longest string.
local function longest_string(strings)
  local length = 0
  for _, line in ipairs(strings) do
    if #line > length then
      length = #line
    end
  end

  return length
end

---@param cat_lines table The cat whose fence should be expanded.
---@param main_win_id number The window ID of the main Neovim window.
---@param fence_start? number At what line do the fences start? 15 by default.
local function expand_fence(cat_lines, main_win_id, fence_start)
  fence_start = fence_start or 16

  local win_width = vim.api.nvim_win_get_width(main_win_id)
  local matrix_width, matrix_height = longest_string(cat_lines), #cat_lines
  local total_padding_needed = win_width - matrix_width
  local padding_per_side = math.floor(total_padding_needed / 2)

  local fence_rotation_tip = "_/\\"
  local fence_rotation_post = "|  "
  local empty_space = "   "

  local fence_tip_pad = string.rep(fence_rotation_tip, math.ceil(padding_per_side / #fence_rotation_tip))
  local fence_post_pad = string.rep(fence_rotation_post, math.ceil(padding_per_side / #fence_rotation_tip))
  local empty_space_pad = string.rep(empty_space, math.ceil(padding_per_side / 3))

  local rendered = {}

  for index, line in ipairs(cat_lines) do
    if index == fence_start then
      table.insert(rendered, fence_tip_pad .. line .. fence_tip_pad)
    elseif index > fence_start then
      table.insert(rendered, fence_post_pad .. line .. fence_post_pad)
    else
      table.insert(rendered, empty_space_pad .. line .. empty_space_pad)
    end
  end

  return rendered
end

---@return table
local function random_cat_on_fence()
  math.randomseed(os.time())
  local random_index = math.random(1, #fence_cats)
  local cat_on_fence = fence_cats[random_index]
  return cat_on_fence
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local cmd_height = vim.o.cmdheight
    vim.o.cmdheight = 0

    local main_win = vim.api.nvim_get_current_win()
    local main_buf = vim.api.nvim_win_get_buf(main_win)

    if (#(vim.bo[main_buf].filetype) > 0 or
          #(vim.bo[main_buf].syntax) > 0 or
          vim.bo[main_buf].modified) then
          vim.o.cmdheight = cmd_height
      return
    end

    local win_width = vim.api.nvim_win_get_width(main_win)
    local win_height = vim.api.nvim_win_get_height(main_win)

    local cat_on_fence = random_cat_on_fence()
    local cat_on_fence_height = #cat_on_fence
    local cat_on_fence_width = #cat_on_fence[1]

    -- Calculate the center position of the main window relative to the art.
    local win_relative_center = math.floor((win_width - cat_on_fence_width) / 2)

    -- Create a floating window
    local cat_buf = vim.api.nvim_create_buf(false, true) -- nofile buffer, scratch

    vim.api.nvim_buf_set_lines(cat_buf, 0, -1, false, expand_fence(cat_on_fence, main_win))

    local cat_win = vim.api.nvim_open_win(cat_buf, false, {
      relative = "editor",
      width = win_width,
      height = cat_on_fence_height,
      col = win_relative_center,
      row = win_height,
      -- style = "minimal", -- No line numbers, statusline, etc.
      border = "none" -- You can add a border if you like
    })

    -- vim.api.nvim_set_current_win(main_win)

    -- Disable unnecessary buffer settings
    vim.bo[cat_buf].buftype = "nofile"
    vim.bo[cat_buf].bufhidden = "wipe"
    vim.bo[cat_buf].swapfile = false

    -- lua =vim.api.nvim_get_hl(0, {name="Normal" })
    -- lua =vim.api.nvim_set_hl(0, "NormalFloat", {fg = "#ffffff"})

    vim.wo[cat_win].number = false
    vim.wo[cat_win].relativenumber = false
    vim.wo[cat_win].cursorline = false
    vim.wo[cat_win].cursorcolumn = false
    vim.wo[cat_win].foldcolumn = "0"
    vim.wo[cat_win].spell = false
    vim.wo[cat_win].list = false
    vim.wo[cat_win].signcolumn = "auto"
    vim.wo[cat_win].colorcolumn = ""
    vim.wo[cat_win].statuscolumn = ""


    -- Close the floating window on interaction
    vim.api.nvim_create_autocmd(
      { "StdinReadPre", "StdinReadPost", "BufRead", "TermOpen", "BufNewFile", "ModeChanged", "CursorMoved",
        "CursorMovedI", "ModeChanged", "BufNew", "BufEnter" },
      {
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(cat_win) then
            vim.api.nvim_win_close(cat_win, true)
            vim.o.cmdheight = cmd_height
          end
        end
      })
    --
    -- Recenter the float on window resize
    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        -- Recalculate center position
        local new_win_width = vim.api.nvim_win_get_width(main_win)
        local new_win_height = vim.api.nvim_win_get_height(main_win)

        win_relative_center = math.floor((new_win_width - cat_on_fence_width) / 2)
        -- local new_col = math.floor((new_win_width - art_width) / 2)
        -- local new_row = math.floor((new_win_height - height) / 2)

        if vim.api.nvim_win_is_valid(cat_win) then
          vim.api.nvim_win_set_config(cat_win, {
            relative = "editor",
            width = new_win_width,
            height = cat_on_fence_height,
            col = win_relative_center,
            row = new_win_height,
          })

          vim.api.nvim_buf_set_lines(cat_buf, 0, -1, false, expand_fence(cat_on_fence, main_win))
        end
      end
    })
  end
})

return true
