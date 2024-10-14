---@class Storage
---@field ascii_art? table

---@type Storage
Storage = {}

local imported = ImportModuleTree()

if imported then
  for k, v in pairs(imported) do
    Safe.try(function()
      local stripped = ModuleResolver.purename(k)
      Storage[stripped] = v
    end, function(err, msg)
      print("Error importing module: " .. k)
      print(err)
      print(msg)
    end)
  end
end

return Storage
