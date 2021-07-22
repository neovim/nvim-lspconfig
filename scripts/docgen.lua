require 'lspconfig'
local configs = require 'lspconfig/configs'
local docgen = require 'lspconfig/docgen'
local components = require 'lspconfig/docgen/components'

local function write_config_readme(list)
  local entries = vim.tbl_map(function(v)
    return { components.config_entry, { entry = v, web = false } }
  end, list)

  local str = docgen.render {
    { components.readme, { list = list } },
    entries,
  }

  docgen.write_file('CONFIG.md', str)
end

local function write_site_readmes(list)
  for _, v in ipairs(list) do
    local str = docgen.render {
      { components.config_entry, { entry = v, web = true } },
    }
    docgen.write_file(string.format('docs/configurations/%s.md', v.name), str)
  end
end

local function write_mkdocs(list)
  local str = docgen.render {
    { components.mkdocs, { list = list } },
  }
  docgen.write_file('mkdocs.yml', vim.trim(str))
end

local function load_configs()
  for _, v in ipairs(vim.fn.glob('lua/lspconfig/*.lua', 1, 1)) do
    local module_name = v:gsub('.*/', ''):gsub('%.lua$', '')
    require('lspconfig/' .. module_name)
  end

  local function load_data(name, docs)
    local data = nil

    if docs.package_json then
      data = docgen.read_remote_json(name, docs.package_json)
      if not data then
        print(string.format('Failed to download package.json for %q at %q', name, docs.package_json))
        os.exit(1)
        return
      end
    end

    return data
  end

  return docgen.tbl_map_keys_sorted(function(config, name)
    local docs = config.document_config.docs or {}
    local label = docs.language_name and string.format('%s (%s)', docs.language_name, name) or name
    local data = load_data(name, docs)

    local settings = {}
    if data then
      local default_settings = (data.contributes or {}).configuration or {}
      settings = default_settings.properties or {}
    end

    return {
      name = name,
      label = label,
      docs = docs,
      settings = settings,
      config = config.document_config,
    }
  end, configs)
end

local list = load_configs()
write_config_readme(list)
write_site_readmes(list)
write_mkdocs(list)
