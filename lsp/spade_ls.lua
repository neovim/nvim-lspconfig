--@brief
--
-- https://gitlab.com/spade-lang/spade/-/tree/main/spade-language-server
--
-- Spade language server.
--
-- `spade-language-server` can be installed by following the instructions
-- [here](https://docs.spade-lang.org/typst/editor_setup.html)
--
-- The default `cmd` assumes that `spade-language-server` binary can be
-- found in `$PATH`.

---@type vim.lsp.Config
return {
  cmd = { 'spade-language-server' },
  filetypes = { 'spade' },
  root_markers = { 'swim.toml' },
}
