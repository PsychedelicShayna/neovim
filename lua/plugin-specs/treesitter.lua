local events = require('lib.events')


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
  "vim",
  "yaml",
  "fsharp",
  "powershell"
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

local ts_lazy_load_commands = {
  "TSBufDisable", "TSBufEnable", "TSBufToggle", "TSConfigInfo",
  "TSDisable", "TSEditQuery", "TSEditQueryUserAfter", "TSEnable",
  "TSInstall", "TSInstallFromGrammar", "TSInstallInfo", "TSInstallSync",
  "TSModuleInfo", "TSToggle", "TSUninstall", "TSUpdate",
  "TSUpdateSync", "TSInstall", "TSInstallInfo", "TSEnable",
  "TSToggle"
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    init = defer_treesitter,
    cmd = ts_lazy_load_commands,
    config = function()
      -- require("nvim-treesitter.install").compilers = { "clang" }

      require("nvim-treesitter.configs").setup {
        ensure_installed      = {},
        sync_install          = false,
        highlight             = {
          enable = true,
          -- disable = function(lang, bufnr)
          --   -- local large_buffers = require("global.control.large_buffers")
          --   -- local check = large_buffers.is_large(bufnr)

          --   -- require("global.control.events").fire {
          --   --   name = "buffer-disable-check",
          --   --   group = "treesitter",
          --   --   data = {
          --   --     enable = check,
          --   --     lang = lang,
          --   --     bufnr = bufnr
          --   --   }
          --   -- }

          --   -- return check
          -- end,
        },
        incremental_selection = { enable = false },
        indent                = { enable = false },
      }

      events.fire {
        name = "loaded",
        group = "treesitter",
      }
    end,
  }
}
