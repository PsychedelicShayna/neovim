return {
  "numToStr/Comment.nvim",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "arduino",
        "c_sharp",
        "comment",
        "cmake",
        "cpp",
        "elixir",
        "c",
        "go",
        "haskell",
        "html",
        "java",
        "javascript",
        "julia",
        "kotlin",
        "lua",
        "python",
        "regex",
        "ruby",
        "rust",
        "typescript",
        "vim"
      },
      callback = function()
        vim.defer_fn(function()
          require("Comment").setup {

            padding = true, -- Add padding to comment/
            sticky = true, -- Cursor stays at current position.
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
        end, 1000)
      end
    })
  end,
  config = false
}
