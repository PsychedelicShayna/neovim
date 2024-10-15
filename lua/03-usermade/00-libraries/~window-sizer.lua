local M = {}

function M.window_resize(height_step, char_code, operation)
  if not operation or not type(operation) == "function" then
    operation = function(current_height, modified_height)
      return current_height + modified_height
    end
  end

  local original_height = vim.api.nvim_win_get_height(0)
  local modified_height = original_height + height_step

  vim.api.nvim_win_set_height(0, modified_height)

  while vim.fn.getchar(0) == char_code do
    local current_height = vim.api.nvim_win_get_height(0)
    modified_height = operation(current_height, modified_height)

    vim.api.nvim_win_set_height(0, modified_height)
  end
end

return M
