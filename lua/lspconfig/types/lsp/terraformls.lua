---@meta

---@class _.lspconfig.settings.terraformls.Terraform.Codelens
---Display reference counts above top level blocks and attributes.
---@field referenceCount? boolean

---@class _.lspconfig.settings.terraformls.Terraform.ExperimentalFeatures
---Enable autocompletion for required fields when completing Terraform blocks. Combine with `#editor.suggest.preview#` and the editor will provide inline snippet suggestions for blocks of code
---@field prefillRequiredFields? boolean
---Enable validating the currently open file on save
---@field validateOnSave? boolean

---@class _.lspconfig.settings.terraformls.Terraform.LanguageServer.Indexing
---Per-workspace list of directory names for the language server to ignore when indexing files
---
---```lua
---default = {}
---```
---@field ignoreDirectoryNames? string[]
---Per-workspace list of paths for the language server to ignore when indexing files
---
---```lua
---default = {}
---```
---@field ignorePaths? string[]

---@class _.lspconfig.settings.terraformls.Terraform.LanguageServer.Tcp
---Language server TCP port to connect to. This is not compatible with `#terraform.languageServer.path#`. This is used when you want the extension to connect via TCP to an already running language server process.
---@field port? number

---@class _.lspconfig.settings.terraformls.Terraform.LanguageServer.Terraform
---Path to a file (`TF_LOG_PATH`) for Terraform executions to be logged used by the the Terraform Language Server. Support for variables (e.g. timestamp, pid, ppid) via Go template syntax `{{varName}}`
---@field logFilePath? string
---Path to the Terraform binary used by the Terraform Language Server
---@field path? string
---Overrides Terraform execution timeout (e.g. 30s) used by the Terraform Language Server
---@field timeout? string

---@class _.lspconfig.settings.terraformls.Terraform.LanguageServer
---Arguments to pass to language server binary
---
---```lua
---default = { "serve" }
---```
---@field args? string[]
---Enable Terraform Language Server
---
---```lua
---default = true
---```
---@field enable? boolean
---Enable warning when opening a single Terraform file instead of a Terraform folder. Enabling this will prevent the message being sent
---@field ignoreSingleFileWarning? boolean
---@field indexing? _.lspconfig.settings.terraformls.Terraform.LanguageServer.Indexing
---Path to the Terraform Language Server binary (optional)
---
---```lua
---default = ""
---```
---@field path? string
---@field tcp? _.lspconfig.settings.terraformls.Terraform.LanguageServer.Tcp
---@field terraform? _.lspconfig.settings.terraformls.Terraform.LanguageServer.Terraform

---@class _.lspconfig.settings.terraformls.Terraform.Mcp.Server
---Enable HashiCorp Terraform MCP Server integration
---@field enable? boolean

---@class _.lspconfig.settings.terraformls.Terraform.Mcp
---@field server? _.lspconfig.settings.terraformls.Terraform.Mcp.Server

---@class _.lspconfig.settings.terraformls.Terraform.Validation
---Enable enhanced validation of Terraform files and modules
---
---```lua
---default = true
---```
---@field enableEnhancedValidation? boolean

---@class _.lspconfig.settings.terraformls.Terraform
---@field codelens? _.lspconfig.settings.terraformls.Terraform.Codelens
---@field experimentalFeatures? _.lspconfig.settings.terraformls.Terraform.ExperimentalFeatures
---@field languageServer? _.lspconfig.settings.terraformls.Terraform.LanguageServer
---@field mcp? _.lspconfig.settings.terraformls.Terraform.Mcp
---@field validation? _.lspconfig.settings.terraformls.Terraform.Validation

---@class lspconfig.settings.terraformls
---@field terraform? _.lspconfig.settings.terraformls.Terraform
