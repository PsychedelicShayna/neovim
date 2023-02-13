local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  -- smartindent = false,                  -- make indenting smarter again
  cindent = true, -- Better than smartindent, doesn't have the same bugs.
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  spelllang = "en_us",
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 250, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  updatetime = 300, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true, -- convert tabs to spaces
  shiftwidth = 4, -- the number of spaces inserted for each indentation
  tabstop = 4, -- insert 2 spaces for a tab
  cursorline = true, -- highlight the current line
  cursorcolumn = true, -- highlight the current column
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 4, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 8, -- is one of my fav
  sidescrolloff = 8,
  guifont = "monospace:h17", -- the font used in graphical neovim applications
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work

-- Places a ruler column 80 as a soft limit, and one at every line after column 120 as a hard limit.
vim.cmd [[ let &colorcolumn="80,120" ]]

vim.cmd [[
  augroup user_options
    autocmd!
    autocmd FileType lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType elixir setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType haskell setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType text setlocal wrap
  augroup user_options
]]

vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = { "*.txt", "*.md", "*.markdown" }, command = "setlocal spell" }
)

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Search", timeout = 150 }
  end
})

-- Disable netrw (built-in file manager), as NvimTree replaces it.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.cmd [[
--   let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
--   let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
--   let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
--   let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
--   set shellquote= shellxquote=
-- ]]
