local file_types = {
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

local function defer_treesitter()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = file_types,
    callback = function(args)
      vim.defer_fn(function()
        require("nvim-treesitter")
        vim.api.nvim_exec_autocmds({ "FileType" }, { pattern = args.match })
      end, 500)

      return true
    end
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = "lukas-reineke/indent-blankline.nvim",
  lazy = true,
  init = defer_treesitter,
  config = function()
    require("nvim-treesitter.install").compilers = { "clang" }

    require("nvim-treesitter.configs").setup {
      ensure_installed      = {},
      sync_install          = false,

      highlight             = { enable = true },
      incremental_selection = { enable = false },
      indent                = { enable = false },
    }
  end,
}
