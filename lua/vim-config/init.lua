-- Where certain features of ViM can be enabled, disabled, or configured.
require "vim-config.options"

-- The default keybindings before any plugin adds or overwrites keybindings.
require "vim-config.keybindings"

-- The colorscheme that will be loaded.
require "vim-config.colorscheme"

-- Neovide configuration. Will only have an effect if Neovide is loaded.
require "vim-config.neovide"

-- Configure the default built-in Neovim LSP client.
require "vim-config.lsp"
