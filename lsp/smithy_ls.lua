---@brief
---
--- https://github.com/awslabs/smithy-language-server
---
--- "Smithy Language Server", a Language server for the Smithy IDL.
---
--- Based off the official maven artifacts setup
--- https://github.com/smithy-lang/smithy-language-server?tab=readme-ov-file#maven-artifacts
---
--- Maven package: https://central.sonatype.com/artifact/software.amazon.smithy/smithy-language-server
--- Adjusting jvm opts: https://get-coursier.io/docs/cli-launch#java-options
---
--- Installation:
--- 1. Install coursier, or any tool that can install maven packages.
---    ```
---    brew install coursier
---    ```
--- 2. The LS is auto-installed and launched by:
---    ```
---    cs launch --contrib smithy-language-server:0.8.0
---    ```

---@type vim.lsp.Config
return {
  cmd = {
    'cs',
    'launch',
    '--contrib',
    'smithy-language-server:0.8.0',
  },
  filetypes = { 'smithy' },
  root_markers = { 'smithy-build.json', 'build.gradle', 'build.gradle.kts', '.git' },
  message_level = vim.lsp.protocol.MessageType.Log,
  init_options = {
    statusBarProvider = 'show-message',
    isHttpEnabled = true,
    compilerOptions = {
      snippetAutoIndent = false,
    },
  },
}
