local colorscheme = "gruvbox-material"
-- local colorscheme = "tokyonight-moon"
-- local colorscheme = "base16-gotham" -- Best with window transparency.
local disable_background = false

if (disable_background) then
  vim.cmd("autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE")
end

local colorscheme_overrides = {
  ["onedark"] = {
    ["BufferLineError"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineDiagnostic"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineHint"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineBuffer"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineWarning"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineWarningDiagnostic"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineWarningVisible"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineInfoDiagnosticVisible"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineInfoDiagnostic"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineInfoVisible"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineHintDiagnosticVisible"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineHintDiagnostic"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineHintVisible"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineDiagnosticVisible"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineNumbersVisible"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineNumbers"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineSeparatorVisible"] = {
      ["fg"] = "#111215",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineErrorVisible"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineErrorDiagnostic"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineErrorDiagnosticVisible"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLinePick"] = {
      ["fg"] = "#ff0000",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineIndicatorVisible"] = {
      ["fg"] = "#282C34",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineInfo"] = {
      ["fg"] = "#ABB2BF",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLineWarningDiagnosticVisible"] = {
      ["fg"] = "#3f4249",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["BufferLinePickVisible"] = {
      ["fg"] = "#ff0000",
      ["bg"] = "#282C34",
      ["enable"] = true
    },
    ["NvimTreeNormal"] = {
      ["fg"] = "#c8ccd4",
      ["bg"] = "#282C34",
      ["enable"] = true
    }
  }
}

-- Bugged colors: 17191D, 1C1F23
-- Main background color: 282C34

-- Bugged needs to match background, and background
-- needs to match the tree view background: 262932

-- Don't crash the entire config if the colorscheme doesn't exist.
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

NotifyColorschemeOverride = false

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
else
  if colorscheme_overrides[colorscheme] then
    if NotifyColorschemeOverride then
      vim.notify("Overriding colorscheme: " .. colorscheme)
    end

    for hname, hvalues in pairs(colorscheme_overrides[colorscheme]) do
      if hvalues["enable"] then
        local command = "highlight " .. hname

        -- If hvalues defines a GUI foreground override, add it to the command.
        if type(hvalues["fg"]) == "string" then
          command = command .. " guifg=" .. hvalues["fg"]
        elseif type(hvalues["fg"]) == "function" then
          command = command .. " guifg=" .. hvalues["fg"]()
        end

        -- If hvalues defines a GUI background override, add it to the command.
        if type(hvalues["bg"]) == "string" then
          command = command .. " guibg=" .. hvalues["bg"]
        elseif type(hvalues["bg"]) == "function" then
          command = command .. " guibg=" .. hvalues["bg"]()
        end

        vim.cmd(command)
      end
    end
  end
end
