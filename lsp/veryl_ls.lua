---@brief
---
--- https://github.com/veryl-lang/veryl
---
--- Language server for Veryl
---
--- `veryl-ls` can be installed via `cargo`:
---  ```sh
---  cargo install veryl-ls
---  ```
return {
  cmd = { 'veryl-ls' },
  filetypes = { 'veryl' },
  root_markers = { '.git' },
}
