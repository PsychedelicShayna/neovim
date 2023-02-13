local plenary_ok, plenary = pcall(require, "plenary")
if not plenary_ok then
  vim.notify("Ignored random_fortune.lua since plenary is missing.")
  return nil
end

math.randomseed(os.time())

local fortune_file_whitelist = {
  "StarTrek",
  "Rules-Of-Acquisition",
  "Computers",
  "Linux",
  "Riddles",
  "Paradoxum",
  "Perl",
  "Platitudes",
  "Tao",
  "Science",
  "Goedel"
}

local M = {}

-- Get a random fortune file from a directory of fortune files.
function M.get_random_fortune_file(fortune_files_dir)
  if fortune_files_dir == nil then
    return nil
  end

  local fortune_files = plenary.scandir.scan_dir(fortune_files_dir, {
    add_dirs = false
  })

  return fortune_files[math.random(1, #(fortune_files))]
end

-- Get a random fortune from a fortune file.
function M.read_random_fortune(fortune_file, line_limit)
  if fortune_file == nil then
    return nil
  end

  local handle = io.open(fortune_file, "r")

  if handle == nil then
    return nil
  end

  local data = handle:read("*a")
  handle:close()

  local fortunes = vim.split(data, "\n%\n", { plain = true })

  if line_limit ~= nil then
    local viable_fortunes = {}

    local count_lines = function(str)
      local count = 0

      for _ in str:gmatch("\n") do
        count = count + 1
      end

      return count
    end

    for _, fortune in ipairs(fortunes) do
      if fortune and count_lines(fortune) <= line_limit then
        table.insert(viable_fortunes, fortune)
      end
    end

    fortunes = viable_fortunes
  end

  return fortunes[math.random(1, #(fortunes))]
end

-- Select a random fortune from a random fortune file.
function M.get_random_fortune(line_limit)
  local fortune_file_dir = vim.fn.stdpath("config")
  fortune_file_dir = fortune_file_dir .. "/lua/fortune/filtered-fortunes/"

  local fortune_file

  if fortune_file_whitelist then
    fortune_file = fortune_file_dir .. fortune_file_whitelist[math.random(1, #(fortune_file_whitelist))]
  else
    fortune_file = M.get_random_fortune_file(fortune_file_dir)
  end

  if not fortune_file then
    return "<Failed to get fortune; fortune_file was nil!>"
  end

  local fortune = M.read_random_fortune(fortune_file, line_limit)

  if not fortune then
    return "<Failed to get fortune; fortune was nil!>"
  end

  return vim.fn.fnamemodify(fortune_file, ":t"), fortune
end

return M
