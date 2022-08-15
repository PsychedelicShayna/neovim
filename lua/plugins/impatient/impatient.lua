local impatient_ok, impatient = pcall(require, "impatient")
if not impatient_ok then
  vim.notify("Could not import impatient from plugins/impatient/impatient.lua")
  return
end

impatient.enable_profile()
