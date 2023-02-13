local lsp_server_list = {
  "clangd", -- C, C++, Objective-C
  "rust_analyzer", -- Rust
  "hls", -- Haskell
  "pyright", -- Python,
  "elixirls", -- Elixir
  "solargraph", -- Ruby,
  "lua_ls", -- Lua
  "fsautocomplete", -- F#
  "kotlin_language_server", -- Kotlin
  "omnisharp", -- C# .NET Runtime
  "jdtls", -- Java
  "eslint", -- JavaScript, TypeScript
  "powershell_es", -- PowerShell
  "neocmake", -- CMake
  "arduino_language_server", -- Arduino
  "asm_lsp", -- Assembly Language
}

-- Configure mason if present.
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
  require("plugins.lsp.mason")(mason)
end

-- Configure mason-lspconfig if present.
local mason_lspcfg_ok, mason_lspcfg = pcall(require, "mason-lspconfig")
if mason_lspcfg_ok then
  require("plugins.lsp.mason-lspconfig")(mason_lspcfg, lsp_server_list)
end

-- Configure lspconfig if present.
local lspconfig_ok, lsp_config = pcall(require, "lspconfig")
if lspconfig_ok then
  require("plugins.lsp.lspconfig")(lsp_config, lsp_server_list)
end

-- Configure null-ls if present.
local null_ls_ok, null_ls = pcall(require, "null-ls")
if null_ls_ok then
  require("plugins.lsp.null-ls")(null_ls)
end

-- Configure lsp-signature if present.
local lsp_signature_ok, lsp_signature = pcall(require, "lsp_signature")
if lsp_signature_ok then
  require("plugins.lsp.lsp_signature")(lsp_signature)
end
