---@meta

---@alias _.lspconfig.settings.tombi.defs.ArrayBracketSpaceWidth integer

---@alias _.lspconfig.settings.tombi.defs.ArrayCommaSpaceWidth integer

---@alias _.lspconfig.settings.tombi.defs.ArrayValuesOrder
---| "ascending"
---| "descending"
---| "version-sort"

---@alias _.lspconfig.settings.tombi.defs.BlankLines integer

---@alias _.lspconfig.settings.tombi.defs.BlankLinesLimit integer

---@alias _.lspconfig.settings.tombi.defs.BoolDefaultFalse boolean

---```lua
---default = true
---```
---@alias _.lspconfig.settings.tombi.defs.BoolDefaultTrue boolean

---@class _.lspconfig.settings.tombi.defs.CargoCodeActionFeatureTree
---Whether code actions can add a dependency to the workspace and inherit it.
---@field ["add-to-workspace-and-inherit-dependency"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can rewrite inline dependencies to table format.
---@field ["convert-dependency-to-table-format"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can inherit dependency settings from the workspace.
---@field ["inherit-dependency-from-workspace"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can replace a value with `workspace = true`.
---@field ["inherit-from-workspace"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can rewrite dependency versions to the latest published version.
---@field ["update-dependency-to-latest-version"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoCodeActionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoCodeActionFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoCompletionFeatureTree
---Whether completion suggests dependency features.
---@field ["dependency-feature"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether completion suggests dependency versions.
---@field ["dependency-version"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether completion suggests filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoCompletionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoCompletionFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoDocumentLinkFeatureTree
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field ["cargo-toml"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse
---Whether document links are created for crates.io package references.
---@field ["crates-io"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field git? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field workspace? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse

---@alias _.lspconfig.settings.tombi.defs.CargoDocumentLinkFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoDocumentLinkFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoExtensionFeatureTree
---@field lsp? _.lspconfig.settings.tombi.defs.CargoLspFeatures

---@alias _.lspconfig.settings.tombi.defs.CargoExtensionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoExtensionFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoGotoDeclarationFeatureTree
---Whether declaration navigation resolves dependency declarations.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Deprecated. This setting is accepted for backward compatibility but ignored.
---@field member? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Deprecated. This setting is accepted for backward compatibility but ignored.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoGotoDeclarationFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoGotoDeclarationFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoGotoDefinitionFeatureTree
---Whether definition navigation resolves dependency targets.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether definition navigation resolves workspace member targets.
---@field member? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether definition navigation resolves filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoGotoDefinitionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoGotoDefinitionFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoHoverFeatureTree
---Whether hover shows default Cargo dependency features.
---@field ["default-features"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether hover shows detailed dependency metadata.
---@field ["dependency-detail"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether hover shows dependencies of the selected Cargo feature.
---@field ["feature-dependencies"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoHoverFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoHoverFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoInlayHintFeatureTree
---Whether inlay hints show `default-features` values.
---@field ["default-features"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether inlay hints show dependency versions.
---@field ["dependency-version"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether inlay hints show values inherited from the Cargo workspace.
---@field ["workspace-value"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoInlayHintFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoInlayHintFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoLspFeatureTree
---@field ["code-action"]? _.lspconfig.settings.tombi.defs.CargoCodeActionFeatures
---@field completion? _.lspconfig.settings.tombi.defs.CargoCompletionFeatures
---@field ["document-link"]? _.lspconfig.settings.tombi.defs.CargoDocumentLinkFeatures
---@field ["goto-declaration"]? _.lspconfig.settings.tombi.defs.CargoGotoDeclarationFeatures
---@field ["goto-definition"]? _.lspconfig.settings.tombi.defs.CargoGotoDefinitionFeatures
---@field hover? _.lspconfig.settings.tombi.defs.CargoHoverFeatures
---@field ["inlay-hint"]? _.lspconfig.settings.tombi.defs.CargoInlayHintFeatures
---@field references? _.lspconfig.settings.tombi.defs.CargoReferencesFeatures

---@alias _.lspconfig.settings.tombi.defs.CargoLspFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoLspFeatureTree

---@class _.lspconfig.settings.tombi.defs.CargoReferencesFeatureTree
---Whether references list dependency-related usages.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.CargoReferencesFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.CargoReferencesFeatureTree

---The style used to format comments.
---@alias _.lspconfig.settings.tombi.defs.CommentStyle "normalize"|"preserve"

---DateTime delimiter
---@alias _.lspconfig.settings.tombi.defs.DateTimeDelimiter "T"|"space"|"preserve"

---@class _.lspconfig.settings.tombi.defs.EnabledOnly
---Whether this feature is enabled.
---@field enabled any

---🚧 Currently, third-party extensions are not supported,
---and only built-in extensions are provided. 🚧
---@class _.lspconfig.settings.tombi.defs.Extensions
---Configure built-in support for `Cargo.toml`.
---@field ["tombi-toml/cargo"]? _.lspconfig.settings.tombi.defs.CargoExtensionFeatures
---Configure built-in support for `pyproject.toml`.
---@field ["tombi-toml/pyproject"]? _.lspconfig.settings.tombi.defs.PyprojectExtensionFeatures
---Configure built-in support for `tombi.toml`.
---@field ["tombi-toml/tombi"]? _.lspconfig.settings.tombi.defs.TombiExtensionFeatures

---@class _.lspconfig.settings.tombi.defs.FilesOptions
---The file match pattern to exclude from formatting and linting.
---Supports glob pattern.
---@field exclude? _.lspconfig.settings.tombi.defs.GlobPattern[]
---The file match pattern to include in formatting and linting.
---Supports glob pattern.
---
---```lua
---default = { "**/*.toml" }
---```
---@field include? _.lspconfig.settings.tombi.defs.GlobPattern[]
---Whether to respect `.ignore`, `.gitignore`, and `.git/info/exclude` while discovering files.
---
---```lua
---default = true
---```
---@field ["respect-ignore-files"]? any

---@class _.lspconfig.settings.tombi.defs.FormatOptions
---@field rules? _.lspconfig.settings.tombi.defs.FormatRules

---@class _.lspconfig.settings.tombi.defs.FormatRules
---```toml
---key = [ 1, 2, 3 ]
---#      ^       ^  <- this
---```
---
---```lua
---default = 0
---```
---@field ["array-bracket-space-width"]? _.lspconfig.settings.tombi.defs.ArrayBracketSpaceWidth
---```toml
---key = [ 1, 2, 3 ]
---#         ^  ^    <- this
---```
---
---```lua
---default = 1
---```
---@field ["array-comma-space-width"]? _.lspconfig.settings.tombi.defs.ArrayCommaSpaceWidth
---- `normalize`: Normalize comment text according to Tombi's formatting rules.
---- `preserve`: Preserve the original comment text while formatting its placement normally.
---
---```lua
---default = "normalize"
---```
---@field ["comment-style"]? _.lspconfig.settings.tombi.defs.CommentStyle
---In accordance with [RFC 3339](https://datatracker.ietf.org/doc/html/rfc3339), you can use `T` or space character between date and time.
---
---- `T`: Use `T` between date and time like `2001-01-01T00:00:00`
---- `space`: Use space between date and time like `2001-01-01 00:00:00`
---- `preserve`: Preserve the original delimiter.
---
---```lua
---default = "T"
---```
---@field ["date-time-delimiter"]? _.lspconfig.settings.tombi.defs.DateTimeDelimiter
---Consecutive groups remain separate for sorting purposes,
---and existing blank lines between them are preserved up to this limit.
---
---```toml
---# BEFORE
---key1 = "value1"
---key2 = "value2"
---
---key3 = "value3"
---
---
---key4 = "value4"
---
---# AFTER (`group-blank-lines-limit = 1`)
---key1 = "value1"
---key2 = "value2"
---
---key3 = "value3"
---
---key4 = "value4"
---```
---
---```lua
---default = 1
---```
---@field ["group-blank-lines-limit"]? _.lspconfig.settings.tombi.defs.BlankLinesLimit
---Whether to use spaces or tabs for indentation.
---
---- `space`: Use spaces for indentation.
---- `tab`: Use tabs for indentation.
---
---```lua
---default = "space"
---```
---@field ["indent-style"]? _.lspconfig.settings.tombi.defs.IndentStyle
---If `true`, the sub-table will be indented.
---
---```toml
---[table]
---    [table.sub-table]
---    key = "value"
---# ^^  <- this
---```
---@field ["indent-sub-tables"]? boolean
---If `true`, the table key-value pairs will be indented.
---
---```toml
---[table]
---    key = "value"
---# ^^  <- this
---```
---@field ["indent-table-key-value-pairs"]? boolean
---⚠️ **WARNING** ⚠️\
---This option is only used when the indentation style is `space`.
---
---```lua
---default = 2
---```
---@field ["indent-width"]? _.lspconfig.settings.tombi.defs.IndentWidth
---```toml
---key = { a = 1, b = 2 }
---#      ^            ^  <- this
---```
---
---```lua
---default = 1
---```
---@field ["inline-table-brace-space-width"]? _.lspconfig.settings.tombi.defs.InlineTableBraceSpaceWidth
---```toml
---key = { a = 1, b = 2 }
---#             ^  <- this
---```
---
---```lua
---default = 1
---```
---@field ["inline-table-comma-space-width"]? _.lspconfig.settings.tombi.defs.InlineTableCommaSpaceWidth
---Choose which quote style the formatter prefers for quoted keys.
---If unspecified, `string-quote-style` is used.
---@field ["key-quote-style"]? _.lspconfig.settings.tombi.defs.StringQuoteStyle
---If `true`, the equals sign in the key-value pairs will be aligned.
---
---⚠️ **WARNING** ⚠️\
---This feature does **not** apply to key-value pairs inside single line inline tables.
---
---```toml
---# BEFORE
---key = "value1"
---key2 = "value2"
---key3.key4 = "value3"
---
---# AFTER
---key       = "value1"
---key2      = "value2"
---key3.key4 = "value3"
---```
---@field ["key-value-equals-sign-alignment"]? boolean
---```toml
---key = "value"
---#  ^ ^  <- this
---```
---
---```lua
---default = 1
---```
---@field ["key-value-equals-sign-space-width"]? _.lspconfig.settings.tombi.defs.KeyValueEqualsSignSpaceWidth
---In TOML, the line ending must be either `LF` or `CRLF`.
---
---- `lf`: Line Feed only (`\n`), common on Linux and macOS as well as inside git repos.
---- `crlf`: Carriage Return Line Feed (`\r\n`), common on Windows.
---
---```lua
---default = "auto"
---```
---@field ["line-ending"]? _.lspconfig.settings.tombi.defs.LineEnding
---The formatter will try to keep lines within this width when specified.
---If omitted, there is no line-width limit.
---@field ["line-width"]? _.lspconfig.settings.tombi.defs.LineWidth
---Choose which quote style the formatter prefers for basic strings.
---
---```lua
---default = "double"
---```
---@field ["string-quote-style"]? _.lspconfig.settings.tombi.defs.StringQuoteStyle
---This applies when the formatter inserts spacing between table or array-of-table blocks.
---
---```toml
---# BEFORE
---[aaa]
---key1 = "value1"
---[bbb]
---key2 = "value2"
---
---# AFTER (`table-blank-lines = 2`)
---[aaa]
---key1 = "value1"
---
---
---[bbb]
---key2 = "value2"
---```
---
---Tight parent/child table adjacency is controlled separately, so this does not apply
---when a child table follows a parent table that has no key-value pairs.
---
---```toml
---# BEFORE
---[aaa]
---
---[aaa.bbb]
---
---# AFTER
---[aaa]
---[aaa.bbb]
---```
---
---```lua
---default = 1
---```
---@field ["table-blank-lines"]? _.lspconfig.settings.tombi.defs.BlankLines
---If `true`, the trailing comments in value/key-value pairs will be aligned.
---
---**📝 NOTE 📝**\
---The trailing comments of table header are not targeted by alignment.
---
---```toml
---# BEFORE
---key = "value1"  # comment 1
---key2 = "value2"  # comment 2
---key3.key4 = "value3"  # comment 3
---
---# AFTER
---key = "value1"        # comment 1
---key2 = "value2"       # comment 2
---key3.key4 = "value3"  # comment 3
---```
---@field ["trailing-comment-alignment"]? boolean
---```toml
---key = "value"  # trailing comment
---#            ^^  <- this
---```
---
---```lua
---default = 2
---```
---@field ["trailing-comment-space-width"]? _.lspconfig.settings.tombi.defs.TrailingCommentSpaceWidth

---Glob pattern used by config include/exclude lists.
---@alias _.lspconfig.settings.tombi.defs.GlobPattern string

---@alias _.lspconfig.settings.tombi.defs.IndentStyle
---| "space"
---| "tab"

---@alias _.lspconfig.settings.tombi.defs.IndentWidth integer

---@alias _.lspconfig.settings.tombi.defs.InlineTableBraceSpaceWidth integer

---@alias _.lspconfig.settings.tombi.defs.InlineTableCommaSpaceWidth integer

---@alias _.lspconfig.settings.tombi.defs.KeyValueEqualsSignSpaceWidth integer

---@alias _.lspconfig.settings.tombi.defs.LineEnding "lf"|"crlf"|"auto"

---@alias _.lspconfig.settings.tombi.defs.LineWidth integer

---@class _.lspconfig.settings.tombi.defs.LintOptions
---@field rules? _.lspconfig.settings.tombi.defs.LintRules

---@class _.lspconfig.settings.tombi.defs.LintRules
---Check if dotted keys are defined out of order.
---
---```toml
---# VALID BUT DISCOURAGED
---apple.type = "fruit"
---orange.type = "fruit"
---apple.skin = "thin"
---orange.skin = "thick"
---
---# RECOMMENDED
---apple.type = "fruit"
---apple.skin = "thin"
---orange.type = "fruit"
---orange.skin = "thick"
---```
---@field ["dotted-keys-out-of-order"]? _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn
---Check if the key is empty.
---
---```toml
---# VALID BUT DISCOURAGED
---"" = true
---```
---@field ["key-empty"]? _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn
---Check if tables are defined out of order.
---
---```toml
---# VALID BUT DISCOURAGED
---[fruit.apple]
---[animal]
---[fruit.orange]
---
---# RECOMMENDED
---[fruit.apple]
---[fruit.orange]
---[animal]
---```
---@field ["tables-out-of-order"]? _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn

---@class _.lspconfig.settings.tombi.defs.LspCodeAction
---Whether to enable code action.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspCompletion
---Whether to enable completion.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspDiagnostic
---Whether to enable diagnostic.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspDocumentLink
---Whether to enable document link.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspFormatting
---Whether to enable formatting.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspGotoDefinition
---Whether to enable goto definition.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspHover
---Whether to enable hover.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspOptions
---@field ["code-action"]? _.lspconfig.settings.tombi.defs.LspCodeAction
---@field completion? _.lspconfig.settings.tombi.defs.LspCompletion
---@field diagnostic? _.lspconfig.settings.tombi.defs.LspDiagnostic
---@field ["document-link"]? _.lspconfig.settings.tombi.defs.LspDocumentLink
---@field formatting? _.lspconfig.settings.tombi.defs.LspFormatting
---@field ["goto-declaration"]? _.lspconfig.settings.tombi.defs.LspGotoDefinition
---@field ["goto-definition"]? _.lspconfig.settings.tombi.defs.LspGotoDefinition
---@field ["goto-type-definition"]? _.lspconfig.settings.tombi.defs.LspGotoDefinition
---@field hover? _.lspconfig.settings.tombi.defs.LspHover
---@field references? _.lspconfig.settings.tombi.defs.LspReferences
---@field ["workspace-diagnostic"]? _.lspconfig.settings.tombi.defs.LspWorkspaceDiagnostic

---@class _.lspconfig.settings.tombi.defs.LspReferences
---Whether to enable references.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.LspWorkspaceDiagnostic
---Whether to enable workspace diagnostic.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.OverrideFilesOptions
---The file match pattern to exclude from formatting and linting.
---Supports glob pattern.
---@field exclude? _.lspconfig.settings.tombi.defs.GlobPattern[]
---The file match pattern to include in formatting and linting.
---Supports glob pattern.
---@field include _.lspconfig.settings.tombi.defs.GlobPattern[]

---@class _.lspconfig.settings.tombi.defs.OverrideFormatOptions
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue
---@field rules? _.lspconfig.settings.tombi.defs.FormatRules

---@class _.lspconfig.settings.tombi.defs.OverrideItem
---@field files any
---@field format? _.lspconfig.settings.tombi.defs.OverrideFormatOptions
---@field lint? _.lspconfig.settings.tombi.defs.OverrideLintOptions

---@class _.lspconfig.settings.tombi.defs.OverrideLintOptions
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue
---@field rules? _.lspconfig.settings.tombi.defs.LintRules

---To apply it to the Root Table, use `""`.
---
---Use `[*]` to match any array element, or a numeric index such as `[1]`
---to match a specific tuple position.
---
---**Example**:
---  - `""`
---  - `"tool.*"`
---  - `"items[*].name"`
---  - `"items[1].name"`
---@alias _.lspconfig.settings.tombi.defs.PatternAccessor string

---@class _.lspconfig.settings.tombi.defs.PyprojectCodeActionFeatureTree
---Whether code actions can add a dependency to the workspace and reuse it.
---@field ["add-to-workspace-and-use-workspace-dependency"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can rewrite dependency versions to the latest published version.
---@field ["update-dependency-to-latest-version"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether code actions can reuse a dependency declared in the workspace.
---@field ["use-workspace-dependency"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectCodeActionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectCodeActionFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectCompletionFeatureTree
---Whether completion suggests filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectCompletionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectCompletionFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectDocumentLinkFeatureTree
---Whether document links are created for `pypi.org` package references.
---@field ["pypi-org"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field ["pyproject-toml"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse

---@alias _.lspconfig.settings.tombi.defs.PyprojectDocumentLinkFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectDocumentLinkFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectExtensionFeatureTree
---@field lsp? _.lspconfig.settings.tombi.defs.PyprojectLspFeatures

---@alias _.lspconfig.settings.tombi.defs.PyprojectExtensionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectExtensionFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectGotoDeclarationFeatureTree
---Whether declaration navigation resolves dependency declarations.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether declaration navigation resolves workspace member declarations.
---@field member? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Deprecated. This setting is accepted for backward compatibility but ignored.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectGotoDeclarationFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectGotoDeclarationFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectGotoDefinitionFeatureTree
---Whether definition navigation resolves dependency targets.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether definition navigation resolves workspace member targets.
---@field member? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether definition navigation resolves filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectGotoDefinitionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectGotoDefinitionFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectHoverFeatureTree
---Whether hover shows detailed dependency metadata.
---@field ["dependency-detail"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectHoverFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectHoverFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectInlayHintFeatureTree
---Whether inlay hints show resolved dependency versions.
---@field ["dependency-version"]? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectInlayHintFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectInlayHintFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectLspFeatureTree
---Configure pyproject code action features.
---@field ["code-action"]? _.lspconfig.settings.tombi.defs.PyprojectCodeActionFeatures
---Configure pyproject completion features.
---@field completion? _.lspconfig.settings.tombi.defs.PyprojectCompletionFeatures
---Configure pyproject document link features.
---@field ["document-link"]? _.lspconfig.settings.tombi.defs.PyprojectDocumentLinkFeatures
---Configure pyproject go-to-declaration features.
---@field ["goto-declaration"]? _.lspconfig.settings.tombi.defs.PyprojectGotoDeclarationFeatures
---Configure pyproject go-to-definition features.
---@field ["goto-definition"]? _.lspconfig.settings.tombi.defs.PyprojectGotoDefinitionFeatures
---Configure pyproject hover features.
---@field hover? _.lspconfig.settings.tombi.defs.PyprojectHoverFeatures
---Configure pyproject inlay hint features.
---@field ["inlay-hint"]? _.lspconfig.settings.tombi.defs.PyprojectInlayHintFeatures
---Configure pyproject references features.
---@field references? _.lspconfig.settings.tombi.defs.PyprojectReferencesFeatures

---@alias _.lspconfig.settings.tombi.defs.PyprojectLspFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectLspFeatureTree

---@class _.lspconfig.settings.tombi.defs.PyprojectReferencesFeatureTree
---Whether references list dependency-related usages.
---@field dependency? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.PyprojectReferencesFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.PyprojectReferencesFeatureTree

---@class _.lspconfig.settings.tombi.defs.RootSchema
---The file match pattern to exclude the target from applying the schema.
---Supports glob pattern.
---@field exclude? _.lspconfig.settings.tombi.defs.GlobPattern[]
---@field format? _.lspconfig.settings.tombi.defs.SchemaFormatOptions
---The file match pattern to include the target to apply the schema.
---Supports glob pattern.
---@field include _.lspconfig.settings.tombi.defs.GlobPattern[]
---@field lint? _.lspconfig.settings.tombi.defs.SchemaLintOptions
---@field overrides? _.lspconfig.settings.tombi.defs.SchemaOverrideItem[]
---@field path string
---If `additionalProperties` is not specified in the JSON Schema,
---the strict mode treats it as `additionalProperties: false`,
---which is different from the JSON Schema specification.
---If omitted, the global `schema.strict` setting is used.
---@field strict? _.lspconfig.settings.tombi.defs.BoolDefaultTrue
---@field ["toml-version"]? _.lspconfig.settings.tombi.defs.TomlVersion

---@class _.lspconfig.settings.tombi.defs.SchemaArrayValuesOrderRule
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.SchemaCatalog
---The catalog is evaluated after the schemas specified by [[schemas]].\
---Schemas are loaded in order from the beginning of the catalog list.
---
---```lua
---default = { "tombi://www.schemastore.org/api/json/catalog.json", "https://www.schemastore.org/api/json/catalog.json" }
---```
---@field paths? _.lspconfig.settings.tombi.defs.SchemaCatalogPath[]

---Schema catalog path or URL
---@alias _.lspconfig.settings.tombi.defs.SchemaCatalogPath string

---@class _.lspconfig.settings.tombi.defs.SchemaFormatOptions
---@field rules? _.lspconfig.settings.tombi.defs.SchemaFormatRules

---@class _.lspconfig.settings.tombi.defs.SchemaFormatRules
---@field ["array-values-order"]? _.lspconfig.settings.tombi.defs.SchemaArrayValuesOrderRule
---@field ["table-keys-order"]? _.lspconfig.settings.tombi.defs.SchemaTableKeysOrderRule

---@alias _.lspconfig.settings.tombi.defs.SchemaItem _.lspconfig.settings.tombi.defs.RootSchema|_.lspconfig.settings.tombi.defs.SubSchema

---@class _.lspconfig.settings.tombi.defs.SchemaLintOptions
---@field rules? _.lspconfig.settings.tombi.defs.SchemaLintRules

---@class _.lspconfig.settings.tombi.defs.SchemaLintRules
---Override the deprecated diagnostic level for this schema.
---@field deprecated? _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn

---@alias _.lspconfig.settings.tombi.defs.SchemaOverrideArrayValuesOrderRule _.lspconfig.settings.tombi.defs.ArrayValuesOrder|_.lspconfig.settings.tombi.defs.SchemaArrayValuesOrderRule

---@class _.lspconfig.settings.tombi.defs.SchemaOverrideFormatOptions
---@field rules? _.lspconfig.settings.tombi.defs.SchemaOverrideFormatRules

---@class _.lspconfig.settings.tombi.defs.SchemaOverrideFormatRules
---@field ["array-values-order"]? _.lspconfig.settings.tombi.defs.SchemaOverrideArrayValuesOrderRule
---@field ["table-keys-order"]? _.lspconfig.settings.tombi.defs.SchemaOverrideTableKeysOrderRule

---@class _.lspconfig.settings.tombi.defs.SchemaOverrideItem
---@field format? _.lspconfig.settings.tombi.defs.SchemaOverrideFormatOptions
---@field lint? _.lspconfig.settings.tombi.defs.SchemaOverrideLintOptions
---@field targets _.lspconfig.settings.tombi.defs.PatternAccessor[]

---@class _.lspconfig.settings.tombi.defs.SchemaOverrideLintOptions
---@field rules? _.lspconfig.settings.tombi.defs.SchemaOverrideLintRules

---@class _.lspconfig.settings.tombi.defs.SchemaOverrideLintRules
---@field deprecated? _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn

---@alias _.lspconfig.settings.tombi.defs.SchemaOverrideTableKeysOrderRule _.lspconfig.settings.tombi.defs.TableKeysOrder|_.lspconfig.settings.tombi.defs.SchemaTableKeysOrderRule

---@class _.lspconfig.settings.tombi.defs.SchemaOverviewOptions
---@field catalog? _.lspconfig.settings.tombi.defs.SchemaCatalog
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue
---If `additionalProperties` is not specified in the JSON Schema,
---the strict mode treats it as `additionalProperties: false`,
---which is different from the JSON Schema specification.
---@field strict? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.SchemaTableKeysOrderRule
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.SeverityLevel
---| "off"
---| "warn"
---| "error"

---```lua
---default = "warn"
---```
---@alias _.lspconfig.settings.tombi.defs.SeverityLevelDefaultWarn any

---The preferred quote character for strings.
---@alias _.lspconfig.settings.tombi.defs.StringQuoteStyle "double"|"single"|"preserve"

---@class _.lspconfig.settings.tombi.defs.SubSchema
---The file match pattern to exclude the target from applying the sub schema.
---Supports glob pattern.
---@field exclude? _.lspconfig.settings.tombi.defs.GlobPattern[]
---@field format? _.lspconfig.settings.tombi.defs.SchemaFormatOptions
---The file match pattern to include the target to apply the sub schema.
---Supports glob pattern.
---@field include _.lspconfig.settings.tombi.defs.GlobPattern[]
---@field lint? _.lspconfig.settings.tombi.defs.SchemaLintOptions
---@field overrides? _.lspconfig.settings.tombi.defs.SchemaOverrideItem[]
---@field path string
---@field root string
---If `additionalProperties` is not specified in the JSON Schema,
---the strict mode treats it as `additionalProperties: false`,
---which is different from the JSON Schema specification.
---This setting takes precedence over the matching root schema setting.
---If omitted, the matching root schema or global `schema.strict` setting is used.
---@field strict? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.TableKeysOrder
---| "ascending"
---| "descending"
---| "schema"
---| "version-sort"

---@class _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse
---Whether this nested feature is enabled.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultFalse

---@class _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue
---Whether this nested feature is enabled.
---@field enabled? _.lspconfig.settings.tombi.defs.BoolDefaultTrue

---@class _.lspconfig.settings.tombi.defs.TombiCompletionFeatureTree
---Whether completion suggests filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.TombiCompletionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiCompletionFeatureTree

---@class _.lspconfig.settings.tombi.defs.TombiDocumentLinkFeatureTree
---Deprecated. This setting is accepted for backward compatibility and will be removed in a future release.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultFalse

---@alias _.lspconfig.settings.tombi.defs.TombiDocumentLinkFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiDocumentLinkFeatureTree

---@class _.lspconfig.settings.tombi.defs.TombiExtensionFeatureTree
---@field lsp? _.lspconfig.settings.tombi.defs.TombiLspFeatures

---@alias _.lspconfig.settings.tombi.defs.TombiExtensionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiExtensionFeatureTree

---@class _.lspconfig.settings.tombi.defs.TombiGotoDefinitionFeatureTree
---Whether go-to-definition resolves filesystem paths.
---@field path? _.lspconfig.settings.tombi.defs.ToggleFeatureDefaultTrue

---@alias _.lspconfig.settings.tombi.defs.TombiGotoDefinitionFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiGotoDefinitionFeatureTree

---@alias _.lspconfig.settings.tombi.defs.TombiHoverFeatureTree table

---@alias _.lspconfig.settings.tombi.defs.TombiHoverFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiHoverFeatureTree

---@class _.lspconfig.settings.tombi.defs.TombiLspFeatureTree
---Configure Tombi completion features.
---@field completion? _.lspconfig.settings.tombi.defs.TombiCompletionFeatures
---Configure Tombi document link features.
---@field ["document-link"]? _.lspconfig.settings.tombi.defs.TombiDocumentLinkFeatures
---Configure Tombi go-to-definition features.
---@field ["goto-definition"]? _.lspconfig.settings.tombi.defs.TombiGotoDefinitionFeatures
---Configure Tombi hover features.
---@field hover? _.lspconfig.settings.tombi.defs.TombiHoverFeatures

---@alias _.lspconfig.settings.tombi.defs.TombiLspFeatures _.lspconfig.settings.tombi.defs.EnabledOnly|_.lspconfig.settings.tombi.defs.TombiLspFeatureTree

---@alias _.lspconfig.settings.tombi.defs.TomlVersion "v1.0.0"|"v1.1.0"|"v1.1.0-preview"

---@alias _.lspconfig.settings.tombi.defs.TrailingCommentSpaceWidth integer

---@class lspconfig.settings.tombi
---@field extensions? _.lspconfig.settings.tombi.defs.Extensions
---@field files? _.lspconfig.settings.tombi.defs.FilesOptions
---@field format? _.lspconfig.settings.tombi.defs.FormatOptions
---@field lint? _.lspconfig.settings.tombi.defs.LintOptions
---@field lsp? _.lspconfig.settings.tombi.defs.LspOptions
---@field overrides? _.lspconfig.settings.tombi.defs.OverrideItem[]
---@field schema? _.lspconfig.settings.tombi.defs.SchemaOverviewOptions
---@field schemas? _.lspconfig.settings.tombi.defs.SchemaItem[]
---TOML version to use if not specified in the schema and comment directive.
---
---```lua
---default = "v1.0.0"
---```
---@field ["toml-version"]? _.lspconfig.settings.tombi.defs.TomlVersion
