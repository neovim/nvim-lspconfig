---@brief
--- https://github.com/SohamTilekar/llvm-ir-studio
---
--- LLVM IR Language Server & Visualizer (`llvm-ir-ls`)
---
--- `llvm-ir-ls` is a native, version-aware Language Server for LLVM Intermediate Representation (`.ll`),
--- providing real-time syntax and version diagnostics (LLVM 14 to 21+), SSA def-use analysis,
--- hover documentation, symbol renaming, and interactive Control Flow Graph (CFG) visualizer.

---@type vim.lsp.Config
return {
  cmd = { 'llvm-ir-ls', 'lsp' },
  filetypes = { 'llvm' },
  root_markers = { '.llvm-ir-ls.toml', '.git' },
}
