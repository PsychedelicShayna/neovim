vim.api.nvim_create_user_command("SwitchHeaderSource", function()
  local file_ext         = vim.fn.expand("%:e")
  local file_name_nx     = vim.fn.expand("%:t:r")

  local valid_extensions = {
    "h", "hpp", "hh", "hxx",
    "c", "cpp", "cc", "cxx"
  }

  ---@type string?
  local opposite_ext     = nil

  for idx, ext in ipairs(valid_extensions) do
    if ext == file_ext then
      opposite_ext = idx < 5 and valid_extensions[idx + 4] or valid_extensions[idx - 4]
      break
    end
  end

  if opposite_ext == nil then
    print("Canot deterine the opposite extension for '" .. file_ext .. '"')
    return
  end

  local opposite_file = string.format("%s.%s", file_name_nx, opposite_ext)
  local opposite_path = string.format("%s/%s", vim.fn.expand("%:p:h"), opposite_file)

  if vim.fn.filereadable(opposite_path) == 0 then
    print("Cannot find the opposite file: " .. opposite_path)
    return
  end

  vim.cmd("edit " .. opposite_path)
end, {})
