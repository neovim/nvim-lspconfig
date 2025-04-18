---@brief
---
--- https://github.com/bufbuild/buf-language-server
---
--- `buf-language-server` can be installed via `go install`:
--- ```sh
--- go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
--- ```
---
--- bufls is a Protobuf language server compatible with Buf modules and workspaces
return {
  cmd = { 'bufls', 'serve' },
  filetypes = { 'proto' },
  root_markers = { 'buf.work.yaml', '.git' },
}
