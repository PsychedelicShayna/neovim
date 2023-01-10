local fortune_data_root = "C:/Langs/Python/3.10.5/etc/fortune/"
local fortune_files_dir = fortune_data_root .. "fortune-files/"
local command_template = "fortune \"%s\""

local default_fortune_file_list = {
  "Art",
  "Ascii-art",
  "Computers",
  --[[ "Cookie", ]]
  "Debian",
  --[[ "Definitions", ]]
  --[[ "Disclaimer", ]]
  --[[ "Drugs", ]]
  --[[ "Education", ]]
  --[[ "Ethnic", ]]
  --[[ "Food", ]]
  --[[ "Fortunes", ]]
  --[[ "Goedel", ]]
  --[[ "Humorists", ]]
  --[[ "Kids", ]]
  "Knghtbrd",
  --[[ "Law", ]]
  "Linux",
  --[[ "Literature", ]]
  "Love",
  --[[ "Magic", ]]
  --[[ "Medicine", ]]
  --[[ "Men-Women", ]]
  --[[ "Miscellaneous", ]]
  --[[ "News", ]]
  --[[ "Offensive", ]] -- This does not actually contain fortunes, it's a disclaimer.
  "Paradoxum",
  --[[ "People", ]]
  --[[ "Perl", ]]
  --[[ "Pets", ]]
  "Platitudes",
  --[[ "Politics", ]]
  --[[ "Pratchett", ]]
  "Riddles",
  "Rules-Of-Acquisition",
  "Science",
  --[[ "Songs-Poems", ]]
  --[[ "Sports", ]]
  "StarTrek",
  --[[ "Tao", ]]
  --[[ "Translate-Me", ]]
  --[[ "Wisdom", ]]
  --[[ "Work", ]]
  --[[ "zippy", ]]
}

local function count_chars(string, character)
  local char_counter = 0

  for i = 1, #string do
    if string:sub(i, i) == character then
      char_counter = char_counter + 1
    end
  end

  return char_counter
end

local read_random_fortune = function(file_path)
  local f = io.open(file_path, "r")
  local data = file.read(f, "*a")

end

function GetRandomFortune(fortune_files, maxlines)
  if fortune_files == nil then
    fortune_files = default_fortune_file_list
  end

  local chosen_fortune = nil
  local chosen_fortune_file = nil

  while chosen_fortune == nil do
    local random_fortune_file = fortune_files[math.random(1, #(fortune_files))]
    local full_path = fortune_files_dir .. random_fortune_file
    local command = string.format(command_template, full_path)

    local handle = io.popen(command)

    if handle ~= nil then
      local random_fortune = handle:read("*a")
      handle:close()

      if maxlines == nil or (maxlines ~= nil and count_chars(random_fortune, "\n") <= maxlines) then
        chosen_fortune = random_fortune
        chosen_fortune_file = random_fortune_file
        break
      end
    else
      return "ERROR: Failed to open a handle to fortune file: " .. full_path, nil
    end
  end

  return chosen_fortune, chosen_fortune_file
end
