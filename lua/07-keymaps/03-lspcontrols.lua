-- View Signature
MapKey { key = "<leader>lS", does = "<cmd>lua vim.lsp.buf.signature_help()<cr>", modes = "n", desc = "Signatures" }

-- Search for Symbols/Identifiers
MapKey { key = "<leader>ls", does = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", modes = "n", desc = "Identifier" }

-- Toggle Format on Save
MapKey { key = "<leader>lF", does = "<cmd>:ToggleAutoFormat<cr>", modes = "n", desc = "Toggle AutoFormat" }

-- Format
MapKey { key = "<leader>lf", does = "<cmd>lua vim.lsp.buf.format { async = true }<cr>", modes = "n", desc = "Format" }

-- Code Action
MapKey { key = "<leader>la", does = "<cmd>lua vim.lsp.buf.code_action()<cr>", modes = "n", desc = "Code Action" }

-- Find References
MapKey { key = "<leader>lR", does = "<cmd>Telescope lsp_references<cr>", modes = "n", desc = "References" }

-- Rename
MapKey { key = "<leader>lr", does = "<cmd>lua vim.lsp.buf.rename()<cr>", modes = "n", desc = "Rename" }

-- Hover
MapKey { key = "<leader>lh", does = "<cmd>lua vim.lsp.buf.hover()<cr>", modes = "n", desc = "Hover" }

-- Find Declaration & Definition
MapKey { key = "<leader>lD", does = "<cmd>lua vim.lsp.buf.declaration()<cr>", modes = "n", desc = "Declarations" }
MapKey { key = "<leader>ld", does = "<cmd>Telescope lsp_definitions<cr>", modes = "n", desc = "Definitions" }

-- Switch between header and source files for C/C++
MapKey { key = "<leader>lH", does = ":SwitchHeaderSource<cr>", modes = "n" }
