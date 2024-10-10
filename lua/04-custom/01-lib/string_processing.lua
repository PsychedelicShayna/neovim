Str = {}

---@param str string
---@return string?
function Str.trim(str)
    if type(str) ~= 'string' then
        return nil
    end

    return str:match("^%s*(.-)%s*$")
end

return Str
