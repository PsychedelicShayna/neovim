return {
  "andweeb/presence.nvim",
  lazy = true,
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        vim.defer_fn(function()
          require("presence")
        end, 5000)

        return true
      end
    })
  end,
  config = function()
    require("presence").setup {
      auto_update         = true,
      neovim_image_text   = "The One True Text Editor",
      main_image          = "file",
      log_level           = nil,
      debounce_timeout    = 10,
      enable_line_number  = false,
      blacklist           = { "*//*:pwsh&::toggleterm::*" },
      buttons             = false,
      file_assets         = {},
      editing_text        = "Editing %s",
      file_explorer_text  = "Browsing %s",
      git_commit_text     = "Committing Changes",
      plugin_manager_text = "Managing Plugins",
      reading_text        = "Reading %s",
      workspace_text      = "Working on %s",
      line_number_text    = "Line %s out of %s",
    }
  end,
}
