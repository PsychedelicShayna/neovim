function MapKey(binding)
  if (type(binding) ~= 'table'
        or not binding.key
        or not binding.does
        or type(binding.key) ~= 'string'
        or type(binding.does) ~= 'string'
      ) then
    return false
  end

  if not binding.in_mode or type(binding.in_mode) ~= 'string' then
    binding.in_mode = 'n'
  end

  if not binding.with_options or type(binding.with_options) ~= 'table' then
    binding.with_options = {
      noremap = true,
      silent = true
    }
  end

  vim.api.nvim_set_keymap(
    binding.in_mode,
    binding.key,
    binding.does,
    binding.with_options
  )
end
