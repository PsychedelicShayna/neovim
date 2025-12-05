local M = {}

vim.g.autoformat_enabled = false

-- Entries consist of a language, and a list of valid formatters for it.
-- Formatters can be swapped out by using the Afmt command to set formatter.

M.available_formatters = {
  -- ['python'] = {
  --   name = "black", command = "black -q %s"
  -- },

  ['lua'] = {
    name = "stylua", command = "stylua %s"
  }
}

vim.api.nvim_create_user_command("Autoformat", function(opts)
  local state = opts.args[1] or 'toggle'
  local scope = opts.args[2] or 'buffer'

  if state == 'toggle' then
    if scope == 'buffer' then
      local bufnr = vim.api.nvim_get_current_buf()
      local exists, old_state = pcall(vim.api.nvim_buf_get_var, bufnr, 'autoformat_enabled')

      if not exists or (exists and type(old_state) ~= 'boolean') then
        vim.api.nvim_buf_set_var(bufnr, 'autoformat_enabled', true)
        return
      end

      vim.api.nvim_buf_set_var(bufnr, 'autoformat_enabled', not old_state)
    elseif scope == 'global' then
      if type(vim.g.autoformat_enabled) ~= 'boolean' then
        vim.g.autoformat_enabled = true
        return
      end

      vim.g.autoformat_enabled = not vim.g.autoformat_enabled
      return
    end
  end


  local new_state = state == 'enable'

  if scope == 'buffer' then
    vim.api.nvim_buf_set_var(0, 'autoformat_enabled', new_state)
  elseif scope == 'global' then
    vim.g.autoformat_enabled = new_state
  end
end, {
  nargs = '?'
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function(opts)
    local file_type = opts.match
    local bufnr = opts.buf

    local formatter = M.available_formatters[file_type]

    if formatter then
      vim.api.nvim_buf_set_var(bufnr, "autoformat", formatter)
    end
  end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function(opts)
    local bufnr = opts.buf

    local do_format = function()
      local has_custom, formatter = pcall(vim.api.nvim_buf_get_var, bufnr, "autoformat")

      if has_custom then
        local full_path = vim.api.nvim_buf_get_name(bufnr)
        local command = string.format(formatter.command, full_path)
        vim.cmd.norm(":!" .. command .. "\")
        vim.cmd.norm(":e\")
      else
        vim.lsp.buf.format({ async = true })
      end
    end

    local exists, state = pcall(vim.api.nvim_buf_get_var, bufnr, 'autoformat_enabled')

    -- Buffer local takes precedence.
    if exists and type(state) == 'boolean' then
      if state == false then
        return
      else
        do_format()
        return
      end
    end

    if type(vim.g.autoformat_enabled) == 'boolean' then
      if vim.g.autoformat_enabled then
        do_format()
        return
      end
    end
  end
})

return M
