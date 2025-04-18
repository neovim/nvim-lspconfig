---@brief
---
--- https://github.com/digama0/mm0
---
--- Language Server for the metamath-zero theorem prover.
---
--- Requires [mm0-rs](https://github.com/digama0/mm0/tree/master/mm0-rs) to be installed
--- and available on the `PATH`.
return {
  cmd = { 'mm0-rs', 'server' },
  root_markers = { '.git' },
  filetypes = { 'metamath-zero' },
}
