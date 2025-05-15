---@brief
---
--- https://github.com/ocaml-lsp/ocaml-language-server
---
--- `ocaml-language-server` can be installed via `npm`
--- ```sh
--- npm install -g ocaml-language-server
--- ```

return {
  cmd = { 'ocaml-language-server', '--stdio' },
  filetypes = { 'ocaml', 'reason' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.opam', 'esy.json', 'package.json' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
}
