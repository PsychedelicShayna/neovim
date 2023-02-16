config = function(plugin)
  require("nvim-treesitter.install").compilers = { "clang" }

  require("nvim-treesitter.configs").setup {
    ensure_installed = {},
    sync_install = false,

    autopairs = {
      enable = true,
    },

    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "" }, -- list of language that will be disabled
      additional_vim_regex_highlighting = false,
    },

    indent = { enable = false },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    rainbow = {
      enable = false,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    },
  }
end

return { "nvim-treesitter/nvim-treesitter",
  config = config,
  lazy = true,

  dependencies = "lukas-reineke/indent-blankline.nvim",

  ft = {
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
  }
}


