vim.api.nvim_create_user_command("ScratchPad", function()
  -- Get a temporary file path; should be unique every time.
  local temp_file_name = vim.fn.tempname()

  -- In case of a conflicting path, re-run the function until
  -- a unique path is generated, and add in the current timestamp
  -- for good measure, to ensure uniqueness.

  while vim.fn.filereadable(temp_file_name) ~= 0 do
    temp_file_name = string.format("%s.%s", vim.fn.tempname(), os.time())
  end

  -- Query the user for the file's extension, which will determine the syntax
  -- highlighting and language server, due to its filetype.
  local extension = vim.fn.input("Extension: ")

  if extension == "" then
    extension = "txt"
  end

  temp_file_name = temp_file_name .. "." .. extension

  -- Write the file first, before opening it in a vertical split, to ensure
  --  it's a fresh read from the disk, triggering all autocmds that would
  --  launch LSP, pick filetype, etc..
  vim.fn.writefile({}, temp_file_name)


  -- Vertical split, and get the current buffer number immediately after.
  vim.cmd("vsplit " .. temp_file_name)
  local bufnr = vim.api.nvim_get_current_buf()

  -- Using the buffer number, create an autocmd to delete the file when the
  -- buffer is closed, but the window may stay open.

  local autocmd = vim.api.nvim_create_autocmd({ "BufDelete" }, {
    buffer = bufnr,
    once = true,
    callback = function()
      Safe.try(function()
        os.remove(temp_file_name)
      end)

      -- Fire a custom command using my Events library, to notify that
      -- this autocmd callback has been called, allowing the autocmd
      -- to be deleted after the file has been deleted, since the ID
      -- of the autocmd is not known at this time.
      Events.fire_event({
        actor = "scratch-pad.lua",
        event = "BufDelete"
      })
    end
  })

  -- Receive the above custom event, delete the autocmd from its now known ID.
  Events.await_event({
    actor = "scratch-pad.lua",
    event = "BufDelete",
    callback = function()
      Safe.try(function()
        vim.api.nvim_del_autocmd(autocmd)
      end)

      return { expire = true }
    end
  })
end, {})
