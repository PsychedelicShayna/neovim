local events = require('prelude').events

 function MapKey(binding)
  if (type(binding) ~= 'table'
        or not binding.key
        or not binding.does
        or type(binding.key) ~= 'string'
        or type(binding.does) ~= 'string'
      ) then
    return false
  end

  if not binding.in_mode or type(binding.in_mode) ~= 'string' then
    binding.in_mode = 'n'
  end

  if not binding.with_options or type(binding.with_options) ~= 'table' then
    binding.with_options = {
      noremap = true,
      silent = true
    }
  end

  vim.api.nvim_set_keymap(
    binding.in_mode,
    binding.key,
    binding.does,
    binding.with_options
  )
end


--Remap space as leader key
---|bind('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

events.fire {
  name = "leader-bound",
  group = "keybindings",
  forget = 1
}

---------------------------------
--    Valid Modes Reference    --
---------------------------------
--  Normal  (N), Insert   (I)  --
--  Visual  (V), VBlock   (X)  --
--  Command (C), Terminal (T)  --
---------------------------------

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


-- Telescope
--
-- This should not assume telescope is installed
-- bind('n', '<A-x>', '<cmd>Telescope commands theme=ivy<cr>')
-- bind('c', '<A-x>', '<cmd>Telescope commands theme=ivy<cr>')