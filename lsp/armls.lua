---@brief
---
--- https://github.com/arm/armls
---
--- ArmLS is a language server for Arm Assembly.
---
--- It supports A32 and A64 assembly and provides hover documentation,
--- completion, diagnostics, document symbols, go-to-definition, and
--- semantic highlighting.
---
--- ArmLS can be installed from the Arm Assembly Support extension on
--- Open VSX or the Visual Studio Marketplace.
---
--- The internal diagnostics engine is currently alpha quality. Arm
--- recommends disabling some operand diagnostics by default and using
--- clang-powered diagnostics when appropriate.

---@type vim.lsp.Config
return {
  cmd = { 'armls' },
  filetypes = { 'asm' },
  settings = {
    armls = {
      diagnostics = {
        enable = true,
        disableCategories = {
          'invalidOperand',
          'tooManyOperands',
          'tooFewOperands',
        },
      },
    },
  },
}
