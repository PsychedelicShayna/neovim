-- Normally, this plugin would be in the plugins folder, but this plugin
-- needs to load as soon as possible in order to yield performance benefits.
-- Impatient speeds up startup times through module compilation.

local impatient_ok, impatient = pcall(require, "impatient")
if not impatient_ok then
  vim.notify("Could not import impatient from plugins/impatient/impatient.lua")
  return
end

impatient.enable_profile()

-- The plugins directory, where the init.lua packer specification file is, and 
-- where all of the plugin configuration directories are.
require "plugins"

-- The vim-config.lua file, containing all of the default ViM configuration options
-- that come with ViM, and don't depend on any plugins.
require "vim-config"
