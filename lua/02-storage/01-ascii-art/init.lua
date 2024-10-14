return function(desired_art)
  local import_path = ModuleResolver.whereami(true)
  import_path = ModuleResolver.ascend(import_path, 1)
  import_path = ModuleResolver.reqformat(import_path)
  import_path = string.format("%s.%s", import_path, desired_art)
  return Safe.import_or(import_path, "Sorry, there is no stored ascii art found at: " .. import_path)
end
