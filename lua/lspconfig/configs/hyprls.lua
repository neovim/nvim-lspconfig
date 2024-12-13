return {
  default_config = {
    cmd = { 'hyprls', '--stdio' },
    filetypes = { 'hyprlang' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/hyprland-community/hyprls

`hyprls` can be installed via `go`:
```sh
go install github.com/ewen-lbh/hyprls/cmd/hyprls@latest
```

]],
  },
}
