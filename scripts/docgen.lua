require 'nvim_lsp'
local skeleton = require 'nvim_lsp/skeleton'
local inspect = vim.inspect

local function filter(...)
  local lines = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    if v then
      table.insert(lines, v)
    end
  end
  return lines
end

local function nilifempty(s)
  if #s == 0 then return end
  return s
end

local function dedent(s)
  local lines = vim.split(s, '\n', true)
  if #lines == 0 then
    return ""
  end
  local indent = #lines[1]:match("^%s*")
  for i = 1, #lines do
    lines[i] = lines[i]:sub(indent)
  end
  return table.concat(lines, '\n')
end

local function template(s, params)
  return (s:gsub("{{([^{}]+)}}", params))
end

local function map_list(t, fn)
  local res = {}
  for i, v in ipairs(t) do table.insert(res, fn(v, i)) end
  return res
end

local function indent(n, s)
  if n <= 0 then return s end
  local lines = vim.split(s, '\n', true)
  for i, line in ipairs(lines) do
    lines[i] = string.rep(" ", n)..line
  end
  return table.concat(lines, '\n')
end

local skeleton_keys = vim.tbl_keys(skeleton)
table.sort(skeleton_keys)

local function make_lsp_sections()
  local sections = map_list(skeleton_keys, function(k)
    local v = skeleton[k]
    local tconf = v.template_config

    local params = {}
    params.template_name = k
    if tconf.commands then
      local lines = {"Commands:"}
      local cnames = vim.tbl_keys(tconf.commands)
      table.sort(cnames)
      for _, cname in ipairs(cnames) do
        local def = tconf.commands[cname]
        if def.description then
          table.insert(lines, string.format("- %s: %s", cname, def.description))
        else
          table.insert(lines, string.format("- %s", cname))
        end
        lines[#lines] = indent(0, lines[#lines])
      end
      params.commands = indent(0, table.concat(lines, '\n'))
    end
    if tconf.default_config then
      local lines = {}
      lines = {"Default Values:"}
      local keys = vim.tbl_keys(tconf.default_config)
      table.sort(keys)
      for _, dk in ipairs(keys) do
        local dv = tconf.default_config[dk]
        local description = tconf.docs and tconf.docs.default_config and tconf.docs.default_config[dk]
        if description and type(description) ~= 'string' then
          description = inspect(description)
        end
        table.insert(lines, indent(2, string.format("%s = %s", dk, description or inspect(dv))))
      end
      params.default_config = indent(0, table.concat(lines, '\n'))
    end
    do
      local body_lines = filter(
      params.commands
      , params.default_config
      )
      params.body = indent(2, table.concat(body_lines, '\n\n'))
    end
    params.preamble = ""
    if tconf.docs then
      local installation_instructions
      if v.install then
        installation_instructions = string.format("Can be installed in neovim with `:LspInstall %s`", k)
      end
      local preamble_parts = filter(
        nilifempty(tconf.docs.description)
        , installation_instructions
      )
      -- Insert a newline after the preamble if it exists.
      if #preamble_parts > 0 then table.insert(preamble_parts, '') end
      params.preamble = table.concat(preamble_parts, '\n')
    end

    return template([[
## {{template_name}}

{{preamble}}
```lua
nvim_lsp.{{template_name}}.setup({config})
nvim_lsp#setup("{{template_name}}", {config})

{{body}}
```
]], params)
  end)
  return table.concat(sections, '\n')
end

local function make_implemented_servers_list()
  local parts = map_list(skeleton_keys, function(k)
    return template("- [{{server}}](https://github.com/neovim/nvim-lsp#{{server}})", {server=k})
  end)
  return table.concat(parts, '\n')
end

local function generate_readme(params)
  vim.validate {
    lsp_server_details = {params.lsp_server_details, 's'};
    implemented_servers_list = {params.implemented_servers_list, 's'};
  }
  local input_template = io.open("scripts/README_template.md"):read("*a")
  local readme_data = template(input_template, params)

  local writer = io.open("README.md", "w")
  writer:write(readme_data)
  writer:close()
end

generate_readme {
  implemented_servers_list = make_implemented_servers_list();
  lsp_server_details = make_lsp_sections();
}

-- vim:et ts=2 sw=2
