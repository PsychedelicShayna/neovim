local function should_skip_greeter()
  -- don't start when opening a file
  if vim.fn.argc() > 0 then return true end

  -- skip stdi;
  if vim.fn.line2byte("$1") ~= -1 then return true end

  -- Handle nvim -M
  if not vim.o.modifiable then return true end

  for _, arg in pairs(vim.v.argv) do
    -- whitelisted arguments
    -- always open
    if arg == "--startuptime"
    then
      return false
    end

    -- blacklisted arguments
    -- always skip
    if arg == "-b"
        -- commands, typically used for scripting
        or arg == "-c" or vim.startswith(arg, "+")
        or arg == "-S"
    then
      return true
    end
  end

  -- base case: don't skip
  return false
end

return should_skip_greeter
