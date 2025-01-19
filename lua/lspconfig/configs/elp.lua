return {
  default_config = {
    cmd = { 'elp', 'server' },
    filetypes = { 'erlang' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'rebar.config', 'erlang.mk', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://whatsapp.github.io/erlang-language-platform

ELP integrates Erlang into modern IDEs via the language server protocol and was
inspired by rust-analyzer.
]],
  },
}
