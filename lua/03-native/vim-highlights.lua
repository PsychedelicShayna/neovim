-- Some simple highlight overrides to the default appearance of having no
-- colorscheme selected be actually bearable.

local highlights = {
  "hi SignColumn guibg=None",
  "hi CursorLine guibg=#202020",
  "hi CursorColumn guibg=#202020",
  "hi ColorColumn guibg=#0E0E0E",
  "hi WinBar guibg=None cterm=Bold",
  "hi WinBarNC cterm=None",
  "hi StatusLine gui=None",
  "hi StatusLineNC gui=None",
  "hi Visual guibg=#202020",
  "hi NonText guifg=#AEA849",
  "hi LineNr guifg=#AEAE40",
  "hi Pmenu guibg=None",
}

local command = table.concat(highlights, ' | ')
vim.cmd(command)


