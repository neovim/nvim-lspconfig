return {
  default_config = {
    cmd = { 'jq-lsp' },
    filetypes = { 'jq' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [=[
https://github.com/wader/jq-lsp
Language server for jq, written using Go.
You can install the server easily using go install:
```sh
# install directly
go install github.com/wader/jq-lsp@master
# copy binary to $PATH
cp $(go env GOPATH)/bin/jq-lsp /usr/local/bin
```
Note: To activate properly nvim needs to know the jq filetype.
You can add it via:
```lua
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])
```
]=],
  },
}
