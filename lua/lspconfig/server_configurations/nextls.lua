return {
  default_config = {
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

**By default, next-ls doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path or platform. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your unzipped next-ls.

```lua
require'lspconfig'.nextls.setup{
    -- Unix
    cmd = { "/path/to/next-ls/next_ls_<darwin|linux>_<arm64|amd64>" };
    -- Windows
    cmd = { "/path/to/next-ls/next_ls_windows_amd64.exe" };
    ...
}
```

'root_dir' is chosen like this: if two or more directories containing `mix.exs` were found when searching directories upward, the second one (higher up) is chosen, with the assumption that it is the root of an umbrella app. Otherwise the directory containing the single mix.exs that was found is chosen.
]],
    default_config = {
      root_dir = '{{see description above}}',
    },
  },
}
