return {
  "numToStr/Comment.nvim",
  lazy = true,
  init = function()
    vim.defer_fn(function()
      require("Comment").setup {
        padding = true, -- Add padding to comment/
        sticky = true,  -- Cursor stays at current position.
        ignore = nil,

        -- Toggle comments in normal mode.
        toggler = {
          line = 'gcc',
          block = 'gbc',
        },

        -- Toggle comments in visual mode.
        opleader = {
          line = 'gc',
          block = 'gb',
        },

        -- Add coments above/below/end of line.
        extra = {
          above = 'gcO',
          below = 'gco',
          eol = 'gcA',
        },

        mappings = {
          basic = true,
          extra = true,
        },
        -- Before/after comment function hooks.
        pre_hook = nil,
        post_hook = nil,
      }
    end, 4000)
  end
}
