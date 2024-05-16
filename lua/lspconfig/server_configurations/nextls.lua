return {
  default_config = {
    cmd = { 'nextls' },
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    root_dir = function(fname)
      local matches = vim.fs.find({ 'mix.exs' }, { upward = true, limit = 2, path = fname })
      local child_or_root_path, maybe_umbrella_path = unpack(matches)
      local root_dir = vim.fs.dirname(maybe_umbrella_path or child_or_root_path)

      return root_dir
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elixir-tools/next-ls

`next-ls` can be installed by following the instructions [here](https://www.elixir-tools.dev/docs/next-ls/installation/).

**By default, next-ls sets its `cmd` to `nextls`; this assumes it was installed via [Homebrew](https://www.elixir-tools.dev/docs/next-ls/installation/#homebrew).**

'root_dir' is chosen like this: if two or more directories containing `mix.exs` were found when searching directories upward, the second one (higher up) is chosen, with the assumption that it is the root of an umbrella app. Otherwise the directory containing the single mix.exs that was found is chosen.
]],
    default_config = {
      root_dir = '{{see description above}}',
    },
  },
}
