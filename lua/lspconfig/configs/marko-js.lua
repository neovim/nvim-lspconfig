return {
  default_config = {
    cmd = { 'marko-language-server', '--stdio' },
    filetypes = { 'marko' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
      https://github.com/marko-js/language-server

      Using the Language Server Protocol to improve Marko's developer experience.

      Can be installed via npm:
      ```
      npm i -g @marko/language-server
      ```
    ]],
  },
}
