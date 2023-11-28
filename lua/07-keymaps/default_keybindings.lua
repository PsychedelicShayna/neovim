--Remap space as leader key
---|bind('', '<Space>', '<Nop>')

--                | N | Normal           | I | Insert
--                | V | Visual           | X | Vblock
--                | C | Command          | T | Terminal

-- Resize with arrows
MapKey({ key = '<C-Up>', does = ':resize -1<CR>' })
MapKey({ key = '<C-Down>', does = ':resize +1<CR>' })
MapKey({ key = '<C-Left>', does = ':vertical resize -1<CR>' })
MapKey({ key = '<C-Right>', does = ':vertical resize +1<CR>' })

-- Navigate buffers
MapKey({ key = '<S-l>', does = ':bnext<CR>' })
MapKey({ key = '<S-h>', does = ':bprevious<CR>' })


---||=========================================================================|
---||
---||          Tab Creation, Deletion, Navigation, and Management
---||
---||=========================================================================|

MapKey({ key = '<M-H>', does = '<cmd>tabprevious<cr>' })
MapKey({ key = '<M-C>', does = '<cmd>tabclose<cr>' })
MapKey({ key = '<M-N>', does = '<cmd>tabnew<cr>' })


---||=========================================================================|
---||
---||         Window Creation, Deletion, Navigation, and Management
---||
---||=========================================================================|
MapKey({ key = '<M-K>', does = '<cmd>split<cr>' })
MapKey({ key = '<M-J>', does = '<cmd>split<cr>' })
MapKey({ key = '<M-H>', does = '<cmd>vsplit<cr>' })
MapKey({ key = '<M-L>', does = '<cmd>vsplit<cr>' })



---||=========================================================================|
---||
---||         Buffer Creation, Deletion, Navigation, and Management
---||
---||-------------------------------------------------------------------------|
MapKey({
  key = '<M-d>',
  does = '<cmd>Bdelete!<cr>'
})

MapKey({
  key = '<M-n>',
  does = '<cmd>ene<cr>'
})

MapKey({
  key = '<M-c>',
  does = '<cmd>close!<cr>'
})

---||=========================================================================|

-- Visual --
-- Stay in indent mode
MapKey
{ key = '<', does = '<gv', in_mode = 'v' }

MapKey
{ key = '>', does = '>gv', in_mode = 'v' }


-- Move text up and down
MapKey
{ key = '<A-j>', does = ':m .+1<CR>==', in_mode = 'v' }

MapKey
{ key = '<A-k>', does = ':m .-2<CR>==', in_mode = 'v' }

MapKey { key = 'p', does = '"_dP', in_mode = 'v' }


-- Visual Block --
-- Move text up and down
MapKey({
  key = 'J',
  does = ":move '>+1<CR>gv-gv",
  in_mode = 'x'
})

MapKey({
  key = 'K',
  does = ":move '<-2<CR>gv-gv",
  in_mode = 'x'
})


MapKey({
  key = '<A-j>',
  does = ":move '>+1<CR>gv-gv",
  in_mode = 'x'
})

MapKey({
  key = '<A-k>',
  does = ":move '<-2<CR>gv-gv",
  in_mode = 'x'
})


-- Terminal --
-- Better terminal navigation
MapKey({
  with_options = { silent = true },
  key = '<M-h>',
  does = '<C-\\><C-N><C-w>h',
  in_mode = 't',
})

MapKey({
  with_options = { silent = true },
  key = '<M-j>',
  does = '<C-\\><C-N><C-w>j',
  in_mode = 't',
})

MapKey({
  with_options = { silent = true },
  key = '<M-k>',
  does = '<C-\\><C-N><C-w>k',
  in_mode = 't',
})

MapKey({
  with_options = { silent = true },
  key = '<M-l>',
  does = '<C-\\><C-N><C-w>l',
  in_mode = 't',
})

MapKey({
  key = '<A-h>',
  does = '<CMD>lua vim.lsp.buf.hover()<CR>',
  in_mode = 'n'
})

MapKey({
  key = '<A-a>',
  does = '<CMD>lua vim.lsp.buf.code_action()<CR>',
  in_mode = 'n'
})

MapKey({
  key = '<A-d>',
  does = '<CMD>lua vim.lsp.buf.definition()<CR>',
  in_mode = 'n'
})

MapKey({
  key = '<A-r>',
  does = '<CMD>lua vim.lsp.buf.rename()<CR>',
  in_mode = 'n'
})

MapKey({
  key = '<A-R>',
  does = '<CMD>lua vim.lsp.buf.references()<CR>',
  in_mode = 'n'
})

-- Telescope
--
-- This should not assume telescope is installed
-- bind('n', '<A-x>', '<cmd>Telescope commands theme=ivy<cr>')
-- bind('c', '<A-x>', '<cmd>Telescope commands theme=ivy<cr>')
