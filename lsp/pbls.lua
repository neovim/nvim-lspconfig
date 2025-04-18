---@brief
---
--- https://git.sr.ht/~rrc/pbls
---
--- Prerequisites: Ensure protoc is on your $PATH.
---
--- `pbls` can be installed via `cargo install`:
--- ```sh
--- cargo install --git https://git.sr.ht/~rrc/pbls
--- ```
---
--- pbls is a Language Server for protobuf
return {
  cmd = { 'pbls' },
  filetypes = { 'proto' },
  root_markers = { '.pbls.toml', '.git' },
}
