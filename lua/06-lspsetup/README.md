# LSP Setup Parameters

I separate the language server setup parameters into files that match the name of the language server. These get automatically detected by lsp.lua, and will be used instead of calling the default setup function for that language server.

More than that, it also serves the purpose of giving me control over how third party plugins should interact or be set up for the language server they compliment or replace. 

Rust and Haskell are good examples of that. 


These are custom setup parameters, not custom language server entries. Those are stored in lspconfigs.
