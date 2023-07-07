local M = {}

function M.add_comment_layer()
end

function M.remove_comment_layer()
end

vim.api.nvim_create_user_command("AddCommentLayer", function(opts)

end, {})

vim.api.nvim_create_user_command("RemoveCommentLayer", function(opts)
  local current_mode = vim.fn.mode()

  local mode_handlers = {
    ['n'] = function()
      local current_line = vim.fn.getline('.')
      local matches = current_line:match('')



      -- Add the comment character to the line.
      line = "-- " .. line
      -- Replace the current line with the commented line.
      vim.fn.setline('.', line)
    end,

    ['v'] = function()
    end,

    ['V'] = function()
    end,

    ['CTRL-v'] = function()
    end
  }

  if mode_handlers[current_mode] then
    mode_handlers[current_mode]()
  end


  -- Check if we are in visual mode or in normal mode.
  if vim.fn.visualmode() == 'v' then
    -- Get the start and end of the visual selection.
    local start = vim.fn.getpos("'<")
    local finish = vim.fn.getpos("'>")
    -- Get the lines in the visual selection.
    local lines = vim.fn.getline(start[2], finish[2])
    -- Loop through the lines and add the comment character.
    for i, line in ipairs(lines) do
      lines[i] = "-- " .. line
    end
    -- Replace the lines in the visual selection with the commented lines.
    vim.fn.setline(start[2], lines)
  else
  end
end, {})
