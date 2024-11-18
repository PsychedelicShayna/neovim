Safe.import_then("luasnip", function(ls)
  local s = ls.snippet
  local i = ls.insert_node

  local fmt = require("luasnip.extras.fmt").fmt

  ls.add_snippets("rust", {
    s("op", fmt("Option<{}>", { i(0) })),
    s("so", fmt("Some<{}>", { i(0) })),
    s("ok", fmt("Ok<{}>", { i(0) })),
    s("pm", fmt("pub mod {};", { i(0) })),
    s("pdb", fmt("eprintln!(\"{{:?}}\", {});", { i(0) })),
    s("ctkc", fmt("KeyCode::Char('{}')", { i(0) })),
    s("ahf", fmt("fn {} ({}) -> ah::Result<()> {{\n{}\n\n    Ok(())\n}}", { i(1),i(2),i(3) })),
    s("ahim", fmt("fn {} (&self, {}) -> ah::Result<()> {{\n{}\n\n    Ok(())\n}}", { i(1),i(2),i(3) })),
    s("ahmm", fmt("fn {} (&mut self, {}) -> ah::Result<()> {{\n{}\n\n    Ok(())\n}}", { i(1),i(2),i(3) })),
    s("ahr", fmt("-> ah::Result<({})> {{\n{}\n)}}", { i(0), i(2) })),
    s("ahb", fmt("ah::bail!(\"{}\",);", { i(0) })),
    s("der", fmt("#[derive(Debug, Clone, Default{})]", { i(0) })),
  })
end)
