local util = require('scripts.gen_types.util')

local M = {}

-- modified from https://gist.githubusercontent.com/williamboman/a01c3ce1884d4b57cc93422e7eae7702/raw/lsp-packages.json
M.index = {
  -- nickel_ls = "https://raw.githubusercontent.com/tweag/nickel/master/lsp/client-extension/package.json",
  als = 'https://raw.githubusercontent.com/AdaCore/ada_language_server/master/integration/vscode/ada/package.json',
  astro = 'https://raw.githubusercontent.com/withastro/language-tools/main/packages/vscode/package.json',
  awkls = 'https://raw.githubusercontent.com/Beaglefoot/awk-language-server/master/client/package.json',
  basedpyright = 'https://raw.githubusercontent.com/DetachHead/basedpyright/main/packages/vscode-pyright/package.json',
  bashls = 'https://raw.githubusercontent.com/bash-lsp/bash-language-server/master/vscode-client/package.json',
  clangd = 'https://raw.githubusercontent.com/clangd/vscode-clangd/master/package.json',
  cssls = 'https://raw.githubusercontent.com/microsoft/vscode/main/extensions/css-language-features/package.json',
  dartls = 'https://raw.githubusercontent.com/Dart-Code/Dart-Code/master/package.json',
  denols = 'https://raw.githubusercontent.com/denoland/vscode_deno/main/package.json',
  elixirls = 'https://raw.githubusercontent.com/elixir-lsp/vscode-elixir-ls/master/package.json',
  elmls = 'https://raw.githubusercontent.com/elm-tooling/elm-language-client-vscode/master/package.json',
  eslint = 'https://raw.githubusercontent.com/microsoft/vscode-eslint/main/package.json',
  flow = 'https://raw.githubusercontent.com/flowtype/flow-for-vscode/master/package.json',
  fsautocomplete = 'https://raw.githubusercontent.com/ionide/ionide-vscode-fsharp/main/release/package.json',
  grammarly = 'https://raw.githubusercontent.com/znck/grammarly/main/extension/package.json',
  haxe_language_server = 'https://raw.githubusercontent.com/vshaxe/vshaxe/master/package.json',
  hhvm = 'https://raw.githubusercontent.com/slackhq/vscode-hack/master/package.json',
  hie = 'https://raw.githubusercontent.com/alanz/vscode-hie-server/master/package.json',
  html = 'https://raw.githubusercontent.com/microsoft/vscode/main/extensions/html-language-features/package.json',
  intelephense = 'https://raw.githubusercontent.com/bmewburn/vscode-intelephense/master/package.json',
  java_language_server = 'https://raw.githubusercontent.com/georgewfraser/java-language-server/master/package.json',
  jdtls = 'https://raw.githubusercontent.com/redhat-developer/vscode-java/master/package.json',
  jsonls = 'https://raw.githubusercontent.com/microsoft/vscode/master/extensions/json-language-features/package.json',
  julials = 'https://raw.githubusercontent.com/julia-vscode/julia-vscode/master/package.json',
  kotlin_language_server = 'https://raw.githubusercontent.com/fwcd/vscode-kotlin/master/package.json',
  ltex = 'https://raw.githubusercontent.com/valentjn/vscode-ltex/develop/package.json',
  lua_ls = 'https://raw.githubusercontent.com/LuaLS/vscode-lua/master/package.json',
  luau_lsp = 'https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/editors/code/package.json',
  omnisharp = 'https://raw.githubusercontent.com/OmniSharp/omnisharp-vscode/master/package.json',
  perlls = 'https://raw.githubusercontent.com/richterger/Perl-LanguageServer/master/clients/vscode/perl/package.json',
  perlnavigator = 'https://raw.githubusercontent.com/bscan/PerlNavigator/main/package.json',
  perlpls = 'https://raw.githubusercontent.com/FractalBoy/perl-language-server/master/client/package.json',
  powershell_es = 'https://raw.githubusercontent.com/PowerShell/vscode-powershell/main/package.json',
  psalm = 'https://raw.githubusercontent.com/psalm/psalm-vscode-plugin/master/package.json',
  puppet = 'https://raw.githubusercontent.com/puppetlabs/puppet-vscode/main/package.json',
  purescriptls = 'https://raw.githubusercontent.com/nwolverson/vscode-ide-purescript/master/package.json',
  pylsp = 'https://raw.githubusercontent.com/python-lsp/python-lsp-server/develop/pylsp/config/schema.json',
  pyright = 'https://raw.githubusercontent.com/microsoft/pyright/master/packages/vscode-pyright/package.json',
  r_language_server = 'https://raw.githubusercontent.com/REditorSupport/vscode-r-lsp/master/package.json',
  rescriptls = 'https://raw.githubusercontent.com/rescript-lang/rescript-vscode/master/package.json',
  rls = 'https://raw.githubusercontent.com/rust-lang/vscode-rust/master/package.json',
  rome = 'https://raw.githubusercontent.com/rome/tools/main/editors/vscode/package.json',
  ruff_lsp = 'https://raw.githubusercontent.com/astral-sh/ruff-vscode/main/package.json',
  rust_analyzer = 'https://raw.githubusercontent.com/rust-analyzer/rust-analyzer/master/editors/code/package.json',
  solargraph = 'https://raw.githubusercontent.com/castwide/vscode-solargraph/master/package.json',
  solidity_ls = 'https://raw.githubusercontent.com/juanfranblanco/vscode-solidity/master/package.json',
  sorbet = 'https://raw.githubusercontent.com/sorbet/sorbet/master/vscode_extension/package.json',
  sonarlint = 'https://raw.githubusercontent.com/SonarSource/sonarlint-vscode/master/package.json',
  sourcekit = 'https://raw.githubusercontent.com/swift-server/vscode-swift/main/package.json',
  spectral = 'https://raw.githubusercontent.com/stoplightio/vscode-spectral/master/package.json',
  stylelint_lsp = 'https://raw.githubusercontent.com/bmatcuk/coc-stylelintplus/master/package.json',
  svelte = 'https://raw.githubusercontent.com/sveltejs/language-tools/master/packages/svelte-vscode/package.json',
  svlangserver = 'https://raw.githubusercontent.com/eirikpre/VSCode-SystemVerilog/master/package.json',
  tailwindcss = 'https://raw.githubusercontent.com/tailwindlabs/tailwindcss-intellisense/master/packages/vscode-tailwindcss/package.json',
  terraformls = 'https://raw.githubusercontent.com/hashicorp/vscode-terraform/master/package.json',
  tinymist = 'https://raw.githubusercontent.com/Myriad-Dreamin/tinymist/refs/heads/main/editors/vscode/package.json',
  ts_ls = 'https://raw.githubusercontent.com/microsoft/vscode/main/extensions/typescript-language-features/package.json',
  typst_lsp = 'https://raw.githubusercontent.com/nvarner/typst-lsp/refs/heads/master/editors/vscode/package.json',
  volar = 'https://raw.githubusercontent.com/vuejs/language-tools/master/extensions/vscode/package.json',
  vtsls = 'https://raw.githubusercontent.com/yioneko/vtsls/main/packages/service/configuration.schema.json',
  vuels = 'https://raw.githubusercontent.com/vuejs/vetur/master/package.json',
  wgls_analyzer = 'https://raw.githubusercontent.com/wgsl-analyzer/wgsl-analyzer/main/editors/code/package.json',
  yamlls = 'https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json',
  zeta_note = 'https://raw.githubusercontent.com/artempyanykh/zeta-note-vscode/main/package.json',
  zls = 'https://raw.githubusercontent.com/zigtools/zls-vscode/master/package.json',
}

---@class LspSchema
---@field package_url string url of the package.json of the LSP server
---@field settings_file string file of the settings json schema of the LSP server
---@field translate? boolean

--- @type table<string, LspSchema>
M.overrides = {
  lua_ls = {
    translate = true,
  },
  jsonls = {
    translate = true,
  },
  ts_ls = {
    translate = true,
  },
  ltex = {
    translate = true,
  },
  html = {
    translate = true,
  },
  cssls = {
    translate = true,
  },
}

---@return table<string, LspSchema>
function M.get_schemas()
  ---@type table<string, LspSchema>
  local ret = {}

  for server, package_json in pairs(M.index) do
    ret[server] = {
      package_url = package_json,
      settings_file = util.path('schemas/' .. server .. '.json'),
    }
  end
  ret = vim.tbl_deep_extend('force', ret, M.overrides)

  return ret
end

function M.translate(props, nls_url)
  local nls = util.json_decode(util.fetch(nls_url)) or {}

  local function translate(desc)
    desc = nls[desc:gsub('%%', '')] or desc
    if type(desc) == 'table' then
      local lines = vim.tbl_values(desc)
      lines = util.flatten(lines)
      table.sort(lines)
      desc = table.concat(lines, '\n\n')
    end
    return desc
  end

  local function fixdoc(node)
    if type(node) == 'table' then
      for k, v in pairs(node) do
        if
          k == 'description'
          or k == 'markdownDescription'
          or k == 'markdownDeprecationMessage'
          or k == 'deprecationMessage'
        then
          node[k] = translate(v)
        end
        if k == 'enumDescriptions' or k == 'markdownEnumDescriptions' then
          for i, d in ipairs(v) do
            v[i] = translate(d)
          end
        end
        fixdoc(v)
      end
    end
  end
  fixdoc(props)
end

---@param schema LspSchema
function M.fetch_schema(schema)
  local json = vim.json.decode(util.fetch(schema.package_url)) or {}
  local config = json.contributes and json.contributes.configuration or json.properties and json

  local properties = vim.empty_dict()

  if vim.islist(config) then
    for _, c in pairs(config) do
      if c.properties then
        for k, v in pairs(c.properties) do
          properties[k] = v
        end
      end
    end
  elseif config.properties then
    properties = config.properties
  end

  local ret = {
    ['$schema'] = 'http://json-schema.org/draft-07/schema#',
    description = json.description,
    properties = properties,
  }

  if schema.translate then
    M.translate(ret, schema.package_url:gsub('package%.json$', 'package.nls.json'))
  end

  return ret
end

function M.clean()
  ---@diagnostic disable-next-line: param-type-mismatch
  for _, f in pairs(vim.fn.expand('schemas/*.json', false, true)) do
    vim.uv.fs_unlink(f)
  end
end

function M.update_schemas()
  local schemas = M.get_schemas()
  local names = vim.tbl_keys(schemas)
  table.sort(names)
  for _, name in ipairs(names) do
    local s = schemas[name]
    print(('Generating schema for %s'):format(name))

    if not util.exists(s.settings_file) then
      local ok, schema = pcall(M.fetch_schema, s)
      if ok then
        util.write_file(s.settings_file, util.json_format(schema))
      end
    end
  end
end

function M.build()
  M.clean()
  M.update_schemas()
end

return M
