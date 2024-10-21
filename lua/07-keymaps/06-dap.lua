-- Session Management.
MapKey { key = "<leader>dsr", does = "<cmd>lua require('dap').restart()<cr>", modes = "n", desc = "Restart Debugging Session" }
MapKey { key = "<leader>dsc", does = "<cmd>lua require('dap').close()<cr>", modes = "n", desc = "Close Debugging Session" }
MapKey { key = "<leader>dst", does = "<cmd>lua require('dap').terminate()<cr>", modes = "n", desc = "Terminate Debugging Session" }
MapKey { key = "<leader>dsd", does = "<cmd>lua require('dap').disconnect()<cr>", modes = "n", desc = "Request Debugger Disconnect" }

-- Control Flow
MapKey { key = "<leader>dr", does = "<cmd>lua require('dap').run_last()<cr>", modes = "n", desc = "Runs Last Debug Adapter Configuration" }
MapKey { key = "<leader>dc", does = "<cmd>lua require('dap').continue()<cr>", modes = "n", desc = "Continue Execution/Start Debugger" }
MapKey { key = "<leader>dC", does = "<cmd>lua require('dap').reverse_continue()<cr>", modes = "n", desc = "Continue Backwards (Reverse Debugging)" }
MapKey { key = "<leader>di", does = "<cmd>lua require('dap').step_into()<cr>", modes = "n", desc = "Step Into" }
MapKey { key = "<leader>do", does = "<cmd>lua require('dap').step_out()<cr>", modes = "n", desc = "Step Out" }
MapKey { key = "<leader>dl", does = "<cmd>lua require('dap').step_over()<cr>", modes = "n", desc = "Step Over" }
MapKey { key = "<leader>dh", does = "<cmd>lua require('dap').step_back()<cr>", modes = "n", desc = "Step Back" }
MapKey { key = "<leader>d;", does = "<cmd>lua require('dap').repl.toggle()<cr>", modes = "n", desc = "Toggle Debugger REPL" }

-- Breakpoints
MapKey { key = "<leader>dbb", does = "<cmd>lua require('dap').toggle_breakpoint()<cr>", modes = "n", desc = "Toggle Breakpoint" }
MapKey { key = "<leader>dbh", does = "<cmd>lua require('dap').run_to_cursor()<cr>", modes = "n", desc = "Break Here & Run" }
MapKey { key = "<leader>dbc", does = "<cmd>lua require('dap').clear_breakpoints()<cr>", modes = "n", desc = "Clear Breakpoints" }
MapKey { key = "<leader>dbl", does = "<cmd>lua require('dap').list_breakpoints()<cr>", modes = "n", desc = "List Breakpoints (QF Window)" }

-- DAP UI
MapKey { key = "<leader>duc", does = "<cmd>lua require('dapui').close()<cr>", modes = "n", desc = "Close DAP UI" }
MapKey { key = "<leader>duo", does = "<cmd>lua require('dapui').open()<cr>", modes = "n", desc = "Open DAP UI" }

