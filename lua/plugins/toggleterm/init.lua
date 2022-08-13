local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = "pwsh",
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal

local pwsh1 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh2 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh3 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh4 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh5 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh6 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh7 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh8 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh9 = Terminal:new({ cmd = "pwsh", hidden = true })
local pwsh0 = Terminal:new({ cmd = "pwsh", hidden = true })

function _TERM_PWSH1_TOGGLE() pwsh1:toggle() end
function _TERM_PWSH2_TOGGLE() pwsh2:toggle() end
function _TERM_PWSH3_TOGGLE() pwsh3:toggle() end
function _TERM_PWSH4_TOGGLE() pwsh4:toggle() end
function _TERM_PWSH5_TOGGLE() pwsh5:toggle() end
function _TERM_PWSH6_TOGGLE() pwsh6:toggle() end
function _TERM_PWSH7_TOGGLE() pwsh7:toggle() end
function _TERM_PWSH8_TOGGLE() pwsh8:toggle() end
function _TERM_PWSH9_TOGGLE() pwsh9:toggle() end
function _TERM_PWSH0_TOGGLE() pwsh0:toggle() end

-- local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

-- function _LAZYGIT_TOGGLE()
-- 	lazygit:toggle()
-- end
