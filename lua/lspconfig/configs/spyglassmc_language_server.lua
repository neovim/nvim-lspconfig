return {
  default_config = {
    cmd = { 'spyglassmc-language-server', '--stdio' },
    filetypes = { 'mcfunction' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'pack.mcmeta' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/SpyglassMC/Spyglass/tree/main/packages/language-server

Language server for Minecraft datapacks.

`spyglassmc-language-server` can be installed via `npm`:

```sh
npm i -g @spyglassmc/language-server
```

You may also need to configure the filetype:

`autocmd BufNewFile,BufRead *.mcfunction set filetype=mcfunction`

This is automatically done by [CrystalAlpha358/vim-mcfunction](https://github.com/CrystalAlpha358/vim-mcfunction), which also provide syntax highlight.
]],
  },
}
