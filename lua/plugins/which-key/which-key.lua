local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify('Could not import "which-key" from whichkey.lua')
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},

	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},

	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},

	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},

	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 25, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},

	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = false, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["e"] = {
    "<cmd>NvimTreeToggle<cr>",
    "Explore File Tree (Toggle)",
  },

  --[[ ["s"] = { "<cmd>lua require(\"telescope.builtin\").spell_suggest(require(\"telescope.themes\").get_cursor({}))<cr>", "Spelling Suggestions" }, ]]
	-- ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },

  -- S -- Use the power of Telescope to search for anything and everything.
  s = {
    name = "Search...",

    f = {
			"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
      "Search Files"
    },

    F = {
			"<cmd>Telescope find_files<cr>",
      "Search Files (+ Preview)"
    },

    R = {
      "<cmd>Telescope oldfiles<cr>",
      "Search Recent Files"
    },

    b = {
      "<cmd>Telescope buffers<cr>",
      "Search Buffers"
    },

    p = {
      "<cmd>Telescope projects<cr>",
      "Search Projects"
    },

    g = {
      "<cmd>Telescope live_grep<cr>",
      "Search File Contents (Live Grep)"
    },

    m = {
      "<cmd>Telescope media_files<cr>",
      "Search Media Files"
    },

    r = {
      "<cmd>Telescope lsp_references<cr>",
      "Search References"
    },

    d = {
      "<cmd>Telescope lsp_definitions<cr>",
      "Search Definitions"
    },

    D = {
      "<cmd>lua vim.lsp.buf.declaration()<cr>",
      "Search Declarations"
    },

    i = {
      -- "<cmd>lua require'telescope.builtin'.diagnostics(require('telescope.themes').get_ivy({ previewer = false, height = 20}))<cr>",
      "<cmd>Telescope diagnostics<cr>",
      "Search Diagnostic"
    },

    h = {
      "<cmd>Telescope search_history<cr>",
      "Search, Search History"
    },

    H = {
      "<cmd>Telescope command_history<cr>",
      "Search Command History"
    },

    v = {
      "<cmd>Telescope vim_options<cr>",
      "Search ViM Options"
    },

    o = {
      "<cmd>Telescope colorscheme",
      "Search Colorschemes"
    },

    s = {
      "<cmd>Telescope symbols<cr>",
      "Search Symbols"
    },
    
    c = {
      "<cmd>Telescope commands<cr>",
      "Search Commands"
    },

    C = {
      "<cmd>Telescope autocommands<cr>",
      "Search AutoCommands"
    },

    k = {
      "<cmd>Telescope keymaps<cr>",
      "Search Keybindings"
    },

    j = {
      "<cmd>Telescope jumplist<cr>",
      "Search Jumplist"
    },
  },

  h = {
		h = {
			"<cmd>lua vim.lsp.buf.hover()<cr>",
			"Hover Symbol",
		},

    s = {
      "<cmd>lua require(\"telescope.builtin\").spell_suggest(require(\"telescope.themes\").get_cursor({}))<cr>",
      "Spelling Suggestions"
    },
  },

  g = {
    name = "Git...",

    c = {
      "<cmd>Telescope git_commits<cr>",
      "Search Commits"
    },

    C = {
      "<cmd>lua vim.notify('Not Implemented')<cr>",
      "Git Commit"
    },

    s = {
      "<cmd>Telescope git_status<cr>",
      "Search Git Status"
    },

    S = {
      "<cmd>Telescope git_stash<cr>",
      "Search Git Stash"
    },

    f = {
      "<cmd>Telescope git_files<cr>",
      "Search Git Files"
    },

    b = {
      "<cmd>Telescope git_bcommits<cr>",
      "Search Branch Commits"
    },

    B = {
      "<cmd>Telescope git_branches<cr>",
      "Search Git Branches"
    }
  },

	-- File Operations
	f = {
		name = "File...",

    w = {
      name = "Write...",

      w = {
        "<cmd>w<cr>",
        "Write Changes"
      },

      W = {
        "<cmd>w!<cr>",
        "Write Changes (Force)"
      },

      a = {
        "<cmd>wa<cr>",
        "Write All Changes"
      },

      A = {
        "<cmd>wa!<cr>",
        "Write All Changes (Force)"
      },
    },

	},

	-- Buffer Operations
	b = {
		name = "Buffer...",

		-- Buffer Finder
		b = {
			"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
			"Select Buffer",
		},

		-- Buffer Finder With Preview
		B = {
			"<cmd>Telescope buffers<cr>",
			"Select Buffer (+ Preview)",
		},

		-- Delete Buffer
		d = {
			"<cmd>Bdelete<cr>",
			"Delete Buffer",
		},

    -- Force Delete Buffer
		D = {
			"<cmd>Bdelete!<cr>",
			"Delete Buffer (Force)",
		},

    a = {
      "<cmd>Alpha<cr>",
      "Alpha Dashboard"
    },

    s ={
      "<cmd>ClangdSwitchSourceHeader<cr>",
      "Switch Source/Header Buffers"
    },

    p = {
      "<cmd>ProjectRootToggle<cr>",
      "Toggle Project AutoRoot"
    }
	},

  w = {
    name = "Window...",

    h = {
      "<cmd>split<cr>",
      "Split Window Horizontally"
    },

    v = {
      "<cmd>vsplit<cr>",
      "Split Window Vertically"
    },

    c = {
      "<cmd>close<cr>",
      "Close Window"
    },

    n = {
      "<cmd>new<cr>",
      "New Window"
    },

    d = {
			"<cmd>lua vim.diagnostic.setloclist()<cr>",
      "Diagnostics Window"
    }
  },

	-- LSP Server
	l = {
		name = "LSP",
		a = {
			"<cmd>lua vim.lsp.buf.code_action()<cr>",
			"Code Action",
		},

		d = {
			"<cmd>Telescope lsp_definitions<cr>",
			"View Definition",
		},

		D = {
			"<cmd>lua vim.lsp.buf.declaration()<CR>",
			"View Declaration",
		},

		f = {
			"<cmd>lua vim.lsp.buf.formatting()<cr>",
			"Format",
		},

		i = {
			"<cmd>lua vim.lsp.buf.implementation()<cr>",
			"View Implementation",
		},

		s = {
			"<cmd>lua vim.lsp.buf.signature_help()<cr>",
			"View Signature",
		},

		y = {
			"<cmd>Telescope lsp_document_symbols<cr>",
			"Find Document Symbols",
		},

		Y = {
			"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
			"Find Workspace Symbols",
		},

		h = {
			"<cmd>lua vim.lsp.buf.hover()<cr>",
			"Hover Over",
		},

		H = {
		  "<cmd>lua require(\"cmp\").mapping.complete()<cr>",
		  "Complete Here"
		},

		c = {
			name = "LSP Server Control",
			i = {
				"<cmd>LspInfo<cr>",
				"View Running LSP Information",
			},

			I = {
				"<cmd>LspInstallInfo<cr>",
				"LSP Language Installer",
			},

			s = {
				"<cmd>LspStart<cr>",
				"Start LSP Server",
			},

			S = {
				"<cmd>LspStop<cr>",
				"Stop LSP Server",
			},

			r = {
				"<cmd>LspRestart<cr>",
				"Restart LSP Server",
			},

			l = {
				"<cmd>LspLog<cr>",
				"Show LSP Logs",
			},
		},

		j = {
			"<cmd>lua vim.diagnostic.goto_next()<CR>",
			"Next Diagnostic",
		},

		k = {
			"<cmd>lua vim.diagnostic.goto_prev()<cr>",
			"Prev Diagnostic",
		},

		l = {
			"<cmd>lua vim.diagnostic.setloclist()<cr>",
			"Diagnostics Location List",
		},

		L = {
			"<cmd>lua vim.lsp.codelens.run()<cr>",
			"CodeLens Action",
		},

		r = {
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			"Rename Symbol",
		},

    R = {
      "<cmd>Telescope lsp_references<cr>",
      "Find References"
    }
	},

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},



	-- n = {
	--   name = "Navigate",
	--   d = {"<cmd>Telescope lsp_definitions<CR>", "Definition"},
	--   D = {"<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration"},
	--   r = {"<cmd>Telescope lsp_references()<CR>", "References"},
	--   i = {"<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation"},
	--   f = {"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", "File"},
	--   F = {"<cmd>Telescope find_files<cr>", "Find File (Preview)" },
	--   b = {"<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", "Buffer"},
	--   g = {"<cmd>Telescope live_grep<CR>", "Live Grep"},

	-- j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
	-- k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
	-- l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
	-- p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
	-- r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
	-- R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
	-- s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
	-- u = {
	--   "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
	--   "Undo Stage Hunk",
	-- },
	-- o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
	-- b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	-- c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
	-- d = {
	--   "<cmd>Gitsigns diffthis HEAD<cr>",
	--   "Diff",
	-- },
	-- },

	-- s = {
	--   name = "Search",
	--   b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
	--   c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
	--   h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
	--   M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
	--   r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
	--   R = { "<cmd>Telescope registers<cr>", "Registers" },
	--   k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
	--   C = { "<cmd>Telescope commands<cr>", "Commands" },
	-- },


	--[[ t = { ]]
	--[[ 	name = "Terminals...", ]]
	--[[ 	a = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH1_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 1", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	s = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH2_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 2", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	d = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH3_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 3", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	f = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH4_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 4", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	h = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH5_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 5", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	j = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH6_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 6", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	k = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH7_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 7", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	l = { ]]
	--[[ 		"<cmd>lua _TERM_PWSH8_TOGGLE()<cr>", ]]
	--[[ 		"Terminal 8", ]]
	--[[ 	}, ]]
 --[[]]
	--[[ 	-- t = { "<cmd>lua _NTOP_TOGGLE()<cr>", "NTOP" }, ]]
	--[[ 	-- p = { "<cmd>lua _IPYTHON_TOGGLE()<cr>", "iPython" }, ]]
	--[[ 	-- -- f = { "<cmd>ToggleTerm direction=float<cr>", "Float" }, ]]
	--[[ 	-- h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" }, ]]
	--[[ 	-- v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" }, ]]
	--[[ }, ]]
}

which_key.setup(setup)
which_key.register(mappings, opts)
