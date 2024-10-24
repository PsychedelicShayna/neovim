Safe.import_then("luasnip", function(ls)
  local s = ls.snippet
  local i = ls.insert_node

  local fmt = require("luasnip.extras.fmt").fmt

  ls.add_snippets("rust", {
    s("Op", fmt("Option<{}>", { i(0) })),
    s("So", fmt("Some<{}>", { i(0) })),
    s("Ok", fmt("Ok<{}>", { i(0) })),
    s("pm", fmt("pub mod {};", { i(0) })),
    s("pdb", fmt("eprintln!(\"{{:?}}\", {});", { i(0) }))
  })
end)
