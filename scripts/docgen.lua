#!/usr/bin/env -S nvim -l
local root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
vim.opt.rtp:append(root)

local util = require 'lspconfig.util'

local function template(s, params)
  return (s:gsub('{{([^{}]+)}}', params))
end

local function map_list(t, func)
  local res = {}
  for i, v in ipairs(t) do
    local x = func(v, i)
    if x ~= nil then
      table.insert(res, x)
    end
  end
  return res
end

local function map_sorted(t, func)
  local res = {}
  for k, v in vim.spairs(t) do
    local x = func(k, v)
    if x ~= nil then
      table.insert(res, x)
    end
  end
  return res
end

local function indent(n, s)
  local prefix = string.rep(' ', n)
  return s:gsub('([^\n]+)', prefix .. '%1')
end

local function make_parts(fns)
  return util.tbl_flatten(map_list(fns, function(v)
    if type(v) == 'function' then
      v = v()
    end
    return { v }
  end))
end

local function make_section(indentlvl, sep, parts)
  local flat = make_parts(parts)
  if not flat or #flat == 0 then
    return ''
  end
  return indent(indentlvl, table.concat(flat, sep))
end

local function readfile(path)
  assert((vim.uv.fs_stat(path) or {}).type == 'file')
  return io.open(path):read '*a'
end

local section_template_txt = [[
------------------------------------------------------------------------------
{{config_name}}

{{preamble}}

Snippet to enable the language server: >lua
  vim.lsp.enable('{{config_name}}')

{{commands}}
Default config:
{{default_values}}
]]

local section_template_md = [[
## {{config_name}}

{{preamble}}

Snippet to enable the language server:
```lua
vim.lsp.enable('{{config_name}}')
```
{{commands}}
Default config:
{{default_values}}

---
]]

--- Converts markdown "```" codeblock to vimdoc format.
local function codeblock_to_vimdoc(doc)
  local function make_fn(before, extra)
    return function(lang, code)
      if not code then
        code = lang
        lang = ''
      end
      -- Indent code by 2 spaces.
      return before .. '>' .. lang .. extra .. code:gsub('[^\n]+', '  %0')
    end
  end

  doc = doc
    -- "```lang" following a nonblank line.
    :gsub('[^%s]\n```(%w+)\n(.-)\n```', make_fn(' ', '\n'))
    -- "```lang" following a blank line.
    :gsub('\n```(%w+)\n(.-)\n```', make_fn('', '\n'))
    -- "```" (no language)
    :gsub('\n```\n(..-)\n```', make_fn('', '\n'))

  return doc
end

--- Gets docstring by looking for "@brief" in a Lua code docstring.
local function extract_brief(text, is_markdown)
  local doc = text:match('%-%-+ *%@brief.-(\n%-%-.*)')
  if not doc then
    return ''
  end
  -- Remove all lines following the last comment ("-- …").
  doc = doc:match('(.-)\n[^-]+')
  -- Remove "--" prefix from all lines.
  doc = doc:gsub('\n%-%-+', '\n')
  -- Remove leading whitespace (shared indent).
  doc = vim.trim(vim.text.indent(0, doc))

  -- Convert codeblocks for vimdoc.
  if not is_markdown then
    doc = codeblock_to_vimdoc(doc)
  end

  return doc
end

local function make_lsp_section(config_sections, config_name, config_file, is_markdown)
  local config = require('lsp.' .. config_name)
  local docstring = extract_brief(readfile(config_file), is_markdown)
  local params = {
    config_name = config_name,
    preamble = docstring,
    commands = '',
    default_values = '',
  }

  -- TODO: get commands by parsing `nvim_buf_create_user_command` calls.
  params.commands = make_section(0, '\n', {
    function()
      if not config.commands or #vim.tbl_keys(config.commands) == 0 then
        return
      end
      return ('\nCommands:\n%s\n'):format(make_section(0, '\n', {
        map_sorted(config.commands, function(name, def)
          if def.description then
            return string.format('- %s: %s', name, def.description)
          end
          return string.format('- %s', name)
        end),
      }))
    end,
  })

  params.default_values = make_section(0, '\n', {
    function()
      return make_section(0, '\n', {
        map_sorted(config, function(k, v)
          if type(v) == 'boolean' then
            return ('- `%s` : `%s`'):format(k, v)
          elseif type(v) ~= 'function' and k ~= 'root_dir' then
            if is_markdown then
              return ('- `%s` :\n  ```lua\n%s\n  ```'):format(k, indent(2, vim.inspect(v)))
            else
              return ('- %s: >lua\n%s'):format(k, indent(2, vim.inspect(v)))
            end
          end

          local file = assert(io.open(config_file, 'r'))
          local linenr = 0
          -- Find the `return` line, where the config starts.
          for line in file:lines() do
            linenr = linenr + 1
            if line:find('^return') then
              break
            end
          end
          io.close(file)
          local config_relpath = vim.fs.relpath(root, config_file)

          -- XXX: "../" because the path is outside of the doc/ dir.
          if is_markdown then
            return ('- `%s`: [../%s:%d](../%s#L%d)'):format(k, config_relpath, linenr, config_relpath, linenr)
          else
            return ('- %s (use "gF" to view): ../%s:%d'):format(k, config_relpath, linenr)
          end
        end),
      })
    end,
  }) .. (is_markdown and '' or '\n<') -- Workaround tree-sitter-vimdoc bug.

  local t = is_markdown and section_template_md or section_template_txt
  table.insert(config_sections, template(t, params))
end

local function make_lsp_sections(is_markdown)
  local lsp_files = vim.fs.find(function(f)
    return f:match('.*%.lua$')
  end, { type = 'file', path = vim.fs.joinpath(root, 'lsp'), limit = math.huge })
  local config_sections = {}

  for _, config_file in ipairs(lsp_files) do
    -- "lua/xx.lua"
    local config_name = config_file:match('lsp/(.-)%.lua$')
    if config_name then
      -- HACK: Avoid variable data (username, pid) in the generated document.
      -- local old_home = vim.env.HOME
      -- local old_cache_home = vim.env.XDG_CACHE_HOME
      -- vim.env.HOME = '/home/user'
      -- vim.env.XDG_CACHE_HOME = '/home/user/.cache'
      local old_fn = vim.fn
      vim.fn = setmetatable({}, {
        __index = function(_t, key)
          if key == 'getpid' then
            return function()
              return 12345
            end
          end
          return old_fn[key]
        end,
      })

      make_lsp_section(config_sections, config_name, config_file, is_markdown)

      -- Reset.
      -- vim.env.HOME = old_home
      -- vim.env.XDG_CACHE_HOME = old_cache_home
      vim.fn = old_fn
    end
  end

  return make_section(0, '\n', config_sections)
end

--- Gets the list of config names and returns "table of contents" as markdown.
local function make_toc()
  local lsp_files = vim.fs.find(function(f)
    return f:match('.*%.lua$')
  end, { type = 'file', path = vim.fs.joinpath(root, 'lsp'), limit = math.huge })
  local server_list = {}

  for _, file_path in ipairs(lsp_files) do
    local config_name = file_path:match('lsp/(.-)%.lua$')
    if config_name then
      table.insert(server_list, template('- [{{server}}](#{{server}})', { server = config_name }))
    end
  end

  return make_section(0, '\n', server_list)
end

local function generate_readme(template_file, params, output_file)
  local input_template = readfile(template_file)
  local readme_data = template(input_template, params)

  local writer = assert(io.open(output_file, 'w'))
  writer:write(readme_data)
  writer:close()
end

generate_readme(vim.fs.joinpath(root, 'scripts/docs_template.md'), {
  toc = make_toc(),
  lsp_server_details = make_lsp_sections(true),
}, vim.fs.joinpath(root, 'doc/configs.md'))

generate_readme(vim.fs.joinpath(root, 'scripts/docs_template.txt'), {
  toc = make_toc(),
  lsp_server_details = make_lsp_sections(false),
}, vim.fs.joinpath(root, 'doc/configs.txt'))
