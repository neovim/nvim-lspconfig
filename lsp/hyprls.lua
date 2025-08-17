---@brief
---
--- https://github.com/hyprland-community/hyprls
---
--- `hyprls` can be installed via `go`:
--- ```sh
--- go install github.com/hyprland-community/hyprls/cmd/hyprls@latest
--- ```
return {
  cmd = { 'hyprls', '--stdio' },
  filetypes = { 'hyprlang' },
  root_markers = { '.git' },
}
