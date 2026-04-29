-- modified from https://gist.githubusercontent.com/williamboman/a01c3ce1884d4b57cc93422e7eae7702/raw/lsp-packages.json
local index = {
  ada_ls = 'https://raw.githubusercontent.com/AdaCore/ada_language_server/master/integration/vscode/ada/package.json',
  angularls = 'https://raw.githubusercontent.com/angular/angular/main/vscode-ng-language-service/package.json',
  ansiblels = 'https://raw.githubusercontent.com/ansible/vscode-ansible/main/package.json',
  astro = 'https://raw.githubusercontent.com/withastro/language-tools/main/packages/vscode/package.json',
  awk_ls = 'https://raw.githubusercontent.com/Beaglefoot/awk-language-server/master/client/package.json',
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
  nickel_ls = 'https://raw.githubusercontent.com/nickel-lang/nickel/master/lsp/vscode-extension/package.json',
  nil_ls = 'https://raw.githubusercontent.com/oxalica/nil/main/editors/coc-nil/package.json',
  nixd = 'https://raw.githubusercontent.com/nix-community/nixd/main/nixd/docs/nixd-schema.json',
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
  ruby_lsp = 'https://raw.githubusercontent.com/Shopify/ruby-lsp/main/vscode/package.json',
  ruff = 'https://raw.githubusercontent.com/astral-sh/ruff/main/ruff.schema.json',
  ruff_lsp = 'https://raw.githubusercontent.com/astral-sh/ruff-vscode/main/package.json',
  rust_analyzer = 'https://raw.githubusercontent.com/rust-analyzer/rust-analyzer/master/editors/code/package.json',
  solargraph = 'https://raw.githubusercontent.com/castwide/vscode-solargraph/master/package.json',
  solidity_ls = 'https://raw.githubusercontent.com/juanfranblanco/vscode-solidity/master/package.json',
  sorbet = 'https://raw.githubusercontent.com/sorbet/sorbet/master/vscode_extension/package.json',
  sourcekit = 'https://raw.githubusercontent.com/swift-server/vscode-swift/main/package.json',
  spectral = 'https://raw.githubusercontent.com/stoplightio/vscode-spectral/master/package.json',
  sqlls = 'https://raw.githubusercontent.com/joe-re/sql-language-server/release/package.json',
  stylelint_lsp = 'https://raw.githubusercontent.com/stylelint/vscode-stylelint/main/package.json',
  stylua = 'https://raw.githubusercontent.com/JohnnyMorganz/StyLua/main/stylua-vscode/package.json',
  svelte = 'https://raw.githubusercontent.com/sveltejs/language-tools/master/packages/svelte-vscode/package.json',
  svlangserver = 'https://raw.githubusercontent.com/eirikpre/VSCode-SystemVerilog/master/package.json',
  tailwindcss = 'https://raw.githubusercontent.com/tailwindlabs/tailwindcss-intellisense/master/packages/vscode-tailwindcss/package.json',
  terraformls = 'https://raw.githubusercontent.com/hashicorp/vscode-terraform/master/package.json',
  tinymist = 'https://raw.githubusercontent.com/Myriad-Dreamin/tinymist/refs/heads/main/editors/vscode/package.json',
  ts_ls = 'https://raw.githubusercontent.com/microsoft/vscode/main/extensions/typescript-language-features/package.json',
  typst_lsp = 'https://raw.githubusercontent.com/nvarner/typst-lsp/refs/heads/master/editors/vscode/package.json',
  volar = 'https://raw.githubusercontent.com/vuejs/language-tools/master/extensions/vscode/package.json',
  vtsls = 'https://raw.githubusercontent.com/yioneko/vtsls/main/packages/service/configuration.schema.json',
  vue_ls = 'https://raw.githubusercontent.com/vuejs/vetur/master/package.json',
  yamlls = 'https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json',
  zls = 'https://raw.githubusercontent.com/zigtools/zls/master/schema.json',
}

---@param url string
---@return string
local function request(url)
  local done = false
  local err
  local body

  vim.net.request(url, nil, function(request_err, response)
    err = request_err
    body = response and response.body or nil
    done = true
  end)

  vim.wait(30000, function()
    return done
  end, 50)

  if not done then
    error(('Timed out downloading %s'):format(url))
  end

  if err then
    error(('Could not download %s: %s'):format(url, err))
  end

  return body
end

---@class LspSchema
---@field package_url string url of the package.json of the LSP server
---@field settings_file string file of the settings json schema of the LSP server
---@field translate? boolean
---@field prefix? string Prepend this string to each schema property.

---@class LspSchemaOverrides : LspSchema
---@field package_url? string
---@field settings_file? boolean

--- @type table<string, LspSchemaOverrides>
local overrides = {
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
  nixd = {
    prefix = 'nixd.',
  },
  zls = {
    prefix = 'zls.',
  },
}

---Builds the effective schema configuration table for each server.
---@return table<string, LspSchema>
local function resolve_schema_configs()
  ---@type table<string, LspSchema>
  local schemas = {}

  for server, package_json in pairs(index) do
    schemas[server] = {
      package_url = package_json,
      settings_file = vim.fs.joinpath(vim.uv.cwd(), 'schemas', server .. '.json'),
    }
  end

  return vim.tbl_deep_extend('force', schemas, overrides)
end

---Replaces localized documentation placeholders in a schema tree in place.
---
---This is used for schemas whose documentation strings are stored in a
---separate `package.nls.json` file instead of inline in `package.json`.
---@param props table
---@param nls_url string
local function translate_schema_docs(props, nls_url)
  local localization = vim.json.decode(request(nls_url), { luanil = { array = true, object = true } }) or {}

  ---Resolves a single description value from the downloaded NLS payload.
  ---@param desc string
  ---@return string
  local function resolve_doc_text(desc)
    desc = localization[desc:gsub('%%', '')] or desc
    if type(desc) == 'table' then
      local message_parts = vim.tbl_values(desc)
      message_parts = vim.iter(message_parts):flatten():totable()
      table.sort(message_parts)
      desc = table.concat(message_parts, '\n\n')
    end
    return desc
  end

  ---Walks a schema node recursively and rewrites localized doc fields in place.
  ---@param node any
  local function rewrite_doc_tree(node)
    if type(node) == 'table' then
      for k, v in pairs(node) do
        if
          k == 'description'
          or k == 'markdownDescription'
          or k == 'markdownDeprecationMessage'
          or k == 'deprecationMessage'
        then
          node[k] = resolve_doc_text(v)
        end
        if k == 'enumDescriptions' or k == 'markdownEnumDescriptions' then
          for i, d in ipairs(v) do
            v[i] = resolve_doc_text(d)
          end
        end
        rewrite_doc_tree(v)
      end
    end
  end
  rewrite_doc_tree(props)
end

---Downloads and normalizes the JSON schema for a single server.
---@param schema LspSchema
---@return table
local function generate_server_schema(schema)
  local package_json = vim.json.decode(request(schema.package_url)) or {}
  local config_schema = package_json.contributes and package_json.contributes.configuration
    or package_json.properties and package_json

  local properties = vim.empty_dict()

  if vim.islist(config_schema) then
    for _, config_section in pairs(config_schema) do
      if config_section.properties then
        for k, v in pairs(config_section.properties) do
          properties[k] = v
        end
      end
    end
  elseif config_schema.properties then
    properties = config_schema.properties
  end

  -- `properties["enable_snippets"]` => `properties["zls.enable_snippets"]`
  if schema.prefix then
    if type(properties) == 'table' then
      local new = vim.empty_dict()
      for key, value in pairs(properties) do
        new[schema.prefix .. key] = value
      end
      properties = new
    end
  end

  local schema_json = {
    ['$schema'] = 'http://json-schema.org/draft-07/schema#',
    description = package_json.description,
    properties = properties,
  }

  if schema.translate then
    translate_schema_docs(schema_json, schema.package_url:gsub('package%.json$', 'package.nls.json'))
  end

  return schema_json
end

---Regenerates all schema files under the local `schemas/` directory.
local function generate_all_schemas()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.fn.delete(vim.fs.joinpath(vim.uv.cwd(), 'schemas'), 'rf')

  local schemas = resolve_schema_configs()
  local names = vim.tbl_keys(schemas)
  table.sort(names)
  for _, name in ipairs(names) do
    local schema_config = schemas[name]
    print(('Generating schema for %s'):format(name))

    if not vim.uv.fs_stat(schema_config.settings_file) then
      local ok, schema_json = pcall(generate_server_schema, schema_config)
      if ok then
        vim.fn.mkdir(vim.fn.fnamemodify(schema_config.settings_file, ':h'), 'p')
        vim.fn.writefile(
          vim.split(vim.json.encode(schema_json, { indent = '  ', sort_keys = true }), '\n', { plain = true }),
          schema_config.settings_file,
          'b'
        )
      end
    end
  end
end

generate_all_schemas()
