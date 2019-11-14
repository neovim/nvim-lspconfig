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

local function indent(n, s)
  if n <= 0 then return s end
  local lines = vim.split(s, '\n', true)
  for i, line in ipairs(lines) do
    lines[i] = string.rep(" ", n)..line
  end
  return table.concat(lines, '\n')
end

local writer = io.popen("cat README_preamble.md - > README.md  common-lsp-docs.md", "w")

for k, v in pairs(skeleton) do
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
    params.preamble = table.concat(filter(
    nilifempty(tconf.docs.description)
    ), '\n\n')
  end

  local section = ([[
## {{template_name}}

{{preamble}}
```
nvim_lsp.{{template_name}}.setup({config})
nvim_lsp#setup("{{template_name}}", {config})

{{body}}
```
]]):gsub("{{(%S+)}}", params)

  writer:write(section)
end

writer:close()
-- vim:et ts=2 sw=2
