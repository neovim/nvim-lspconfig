---@brief
---
--- https://github.com/hyprland-community/hyprls
---
--- `hyprls` can be installed via `go`:
--- ```sh
--- go install github.com/ewen-lbh/hyprls/cmd/hyprls@latest
--- ```
return {
  cmd = { 'hyprls', '--stdio' },
  filetypes = { 'hyprlang' },
  root_markers = { '.git' },
}
