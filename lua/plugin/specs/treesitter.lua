local events = require('prelude').events

-- Determines if treesitter should consider the buffer too large, and thus
-- disable itself to preserve performance.

local function is_buffer_too_large(bufnr)
  if type(bufnr) ~= 'number' then
    return false
  end

  local max_size = 1000 * 1024 -- 1MB

  local byte_count = vim.api.nvim_buf_get_offset(
                       bufnr,
                       vim.api.nvim_buf_line_count(bufnr)
                     )

  if byte_count > max_size then
    return true
  else
    return false
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "lukas-reineke/indent-blankline.nvim",
    lazy = true,

    cmd = {
      "TSBufDisable", "TSBufEnable", "TSBufToggle", "TSConfigInfo",
      "TSDisable", "TSEditQuery", "TSEditQueryUserAfter", "TSEnable",
      "TSInstall", "TSInstallFromGrammar", "TSInstallInfo", "TSInstallSync",
      "TSModuleInfo", "TSToggle", "TSUninstall", "TSUpdate",
      "TSUpdateSync", "TSInstall", "TSInstallInfo", "TSEnable",
      "TSToggle"
    },

    -- Load 250ms after a file type has been set, rather than instantly.
    init = function()
      -- Defer the loading of treesitter until after a file type has been set.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          vim.defer_fn(function()
            require("nvim-treesitter")

            -- Re-fire the filetype autocmd, so that treesitter picks up on it.
            vim.api.nvim_exec_autocmds({ "FileType" }, { pattern = args.match })
          end, 250)

          -- Only needs to run a single time, treesitter will be loaded.
          return true
        end
      })
    end,

    config = function()
      -- Ensure that the correct compiler is being used, especially on Windows
      -- where a Cygwin or MinGW GCC compiler will be used to install parsers,
      -- if available, which is likely since Git for Windows comes with one.
      require("nvim-treesitter.install").compilers = { "clang" }

      require("nvim-treesitter.configs").setup {
        auto_install          = false,
        sync_install          = false,
        ensure_installed      = {},
        ignore_install        = {},
        modules               = {},
        incremental_selection = { enable = false },
        indent                = { enable = false },
        highlight             = {
          enable = true,
          disable = function(_, bufnr)
            local is_too_large = is_buffer_too_large(bufnr)

            if is_too_large then
              events.fire {
                name = "buffer-too-large",
                group = "treesitter",
                data = { bufnr = bufnr }
              }
            end
          end,
        },
      }

      events.fire { name = "setup-ok", group = "treesitter", }
    end,
  }
}
