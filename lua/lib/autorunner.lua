vim.api.nvim_create_user_command("Runner", function(opts)
  local fargs = opts.fargs

  if not (type(fargs) == 'table'
        and #fargs >= 2
        and type(fargs[1]) == 'string'
        and type(fargs[2]) == 'string'
      ) then
    return false
  end

  local action = fargs[1]
  local runner = fargs[2]

  if action ~= "(enable|disable)" then
    action:match('([Ee][Nn][Aa][Bb][Ll][Ee]|[Dd][Ii][Ss][Aa][Bb][Ll][Ee])')
    runner = 12
  end
end, {})
