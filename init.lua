-- Hacky Neovim profiler https://github.com/stevearc/profile.nvim
local should_profile = os.getenv("NVIM_PROFILE")

if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end

vim.keymap.set("", "<f1>", toggle_profile)

-- Normally, this plugin would be in the plugins folder, but this plugin
-- needs to load as soon as possible in order to yield performance benefits.
-- Impatient speeds up startup times through module compilation.
--
-- local impatient_ok, impatient = pcall(require, "impatient")
-- if not impatient_ok then
--   vim.notify("Could not import impatient from plugins/impatient/impatient.lua")
--   return
-- end
-- The vim-config.lua file, containing all of the default ViM configuration options
-- that come with ViM, and don't depend on any plugins.
require "vim-config"


-- impatient.enable_profile()

-- The plugins directory, where the init.lua packer specification file is, and 
-- where all of the plugin configuration directories are.
require "plugins"

