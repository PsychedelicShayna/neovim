-- This module will attempt to use the following table to find a shell and
-- configure Neovim to use it, using the attached config function for each
-- shell entry. If no shell is found, or those that are cannot be configured,
-- then the options simply won't be overwritten, leaving as default.

local M = {}

M.candidate_shells = {
  {
    name = "nu",
    config = function()
      local alt_config_path = vim.fn.stdpath("data") .. '\\nu-config-alt.nu'

      local get_nu_config_path = function()
        local handle = io.popen("nu -c $nu.config-path")

        if not handle then
          vim.notify("Could not run 'nu -c '$nu.config-path'' to get the config path", vim.log.levels.ERROR)
          return
        end

        local file_path = handle:read("*a")
        handle:close()

        file_path = file_path:gsub("\\", "\\\\")
        file_path = file_path:gsub("\n", "")

        return file_path
      end

      local read_nu_config = function()
        local file_path = get_nu_config_path()

        if not file_path then
          return
        end

        if not vim.fn.filereadable(file_path) then
          vim.notify("The nushell config file was deemed unreadable: " .. file_path, vim.log.levels.ERROR)
          return
        end

        local handle = io.open(file_path, "r")

        if handle == nil then
          vim.notify("Could not open a handle to the nushell config file: '" .. file_path .. "'", vim.log.levels.ERROR)
          return
        end

        local data = handle:read("*a")

        if data == nil then
          vim.notify("Could not read the nushell config file: " .. file_path, vim.log.levels.ERROR)
          return
        end

        return data
      end

      local write_alt_nu_config = function(data)
        local handle = io.open(alt_config_path, "w+")

        if not handle then
          vim.notify("Could not open a handle to the alternate nushell config file: " .. alt_config_path,
            vim.log.levels.ERROR)
          return
        end

        local success = handle:write(data)
        handle:close()

        if not success then
          vim.notify("Could not write to the alternate nushell config file: " .. alt_config_path, vim.log.levels.ERROR)
          return
        end

        return success
      end

      vim.api.nvim_create_user_command("SyncNushellConfig", function()
        local in_config = read_nu_config()

        if not in_config then
          return
        end

        local out_config = in_config:gsub("use_ansi_coloring: true", "use_ansi_coloring: false")
        write_alt_nu_config(out_config)
      end, {})

      if vim.fn.filereadable(alt_config_path) == 1 then
        vim.o.shell = "nu -c 'config set config-path " .. alt_config_path .. "'"
      else
        vim.notify("The alternate nushell config was not found at " .. alt_config_path, vim.log.levels.ERROR)
        vim.notify("Try running SyncNushellConfig to generate it, and restart Neovim", vim.log.levels.ERROR)
      end

      vim.o.shell = "nu"
      vim.o.shellquote = ""
      vim.o.shellxquote = ""
      vim.o.shellcmdflag = "--config " .. alt_config_path .. " -c"
      vim.o.shellpipe = "2>&1 | save"
      vim.o.shellredir = ">%s 2>&1"

      return true
    end
  },
  {
    name = "pwsh",
    config = function()
      vim.o.shell = "pwsh"
      vim.o.shellquote = ""
      vim.o.shellxquote = ""
      vim.o.shellcmdflag =
      "-NoLogo -Command $PSStyle.OutputRendering=[System.Management.Automation.OutputRendering]::PlainText;Remove-Alias -Name tee -Force -ErrorAction SilentlyContinue;"
      vim.o.shellpipe = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
      vim.o.shellredir = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    end
  },
  -- {
  --   name = "xonsh",
  --   config = function()
  --   end
  -- },
  -- {
  --   name = "cmd",
  --   config = function()
  --   end
  -- },
  -- {
  --   name = "fish",
  --   config = function()
  --   end
  -- },
  -- {
  --   name = "zsh",
  --   config = function()
  --   end
  -- },
  -- {
  --   name = "bash",
  --   config = function()
  --   end
  -- },
}

function M.configure_shell()
  local failed_shells = {}

  for _, candidate_shell in ipairs(M.candidate_shells) do
    local shell_name = candidate_shell.name
    local config_fn = candidate_shell.config

    local shell_info = {
      shell_name    = shell_name,
      is_executable = nil,
      config_ok     = nil
    }

    shell_info.is_executable = vim.fn.executable(shell_name)

    if shell_info.is_executable == 1 then
      shell_info.config_ok = config_fn()

      if shell_info.config_ok then
        return nil
      end
    end

    table.insert(failed_shells, shell_info)
  end

  return failed_shells
end

local failure = M.configure_shell()

if failure then
  vim.notify("Failed to configure any of the following shells, for the included reasons: " .. vim.inspect(failure))
end

return M
