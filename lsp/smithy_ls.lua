---@brief
---
--- https://github.com/awslabs/smithy-language-server
---
--- "Smithy Language Server", a Language server for the Smithy IDL.
---
--- smithy-language-server has no docs that say how to actually install it(?), so look at:
--- https://github.com/smithy-lang/smithy-vscode/blob/600cfcf0db65edce85f02e6d50f5fa2b0862bc8d/src/extension.ts#L78
---
--- Maven package: https://central.sonatype.com/artifact/software.amazon.smithy/smithy-language-server
---
--- Installation:
--- 1. Install coursier, or any tool that can install maven packages.
---    ```
---    brew install coursier
---    ```
--- 2. The LS is auto-installed and launched by:
---    ```
---    coursier launch software.amazon.smithy:smithy-language-server:0.7.0
---    ```

return {
  -- pass 0 as the first argument to use STDIN/STDOUT for communication
  cmd = {
    'coursier',
    'launch',
    'software.amazon.smithy:smithy-language-server:0.7.0',
    '-M',
    'software.amazon.smithy.lsp.Main',
    '--',
    '0',
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
