local util = require 'lspconfig/util'
local M = {}

function M.indent(n, s)
  local prefix
  if type(n) == 'number' then
    if n <= 0 then
      return s
    end
    prefix = string.rep(' ', n)
  else
    assert(type(n) == 'string', 'n must be number or string')
    prefix = n
  end
  local lines = vim.split(s, '\n', true)
  for i, line in ipairs(lines) do
    lines[i] = prefix .. line
  end
  return table.concat(lines, '\n')
end

function M.excape_markdown_punctuations(str)
  local pattern =
    '\\(\\*\\|\\.\\|?\\|!\\|"\\|#\\|\\$\\|%\\|\'\\|(\\|)\\|,\\|-\\|\\/\\|:\\|;\\|<\\|=\\|>\\|@\\|\\[\\|\\\\\\|\\]\\|\\^\\|_\\|`\\|{\\|\\\\|\\|}\\)'
  return vim.fn.substitute(str, pattern, '\\\\\\0', 'g')
end

function M.parse_description(v)
  if type(v) == 'function' then
    local info = debug.getinfo(v)
    local file = io.open(string.sub(info.source, 2), 'r')

    local fileContent = {}
    for line in file:lines() do
      table.insert(fileContent, line)
    end
    io.close(file)

    local root_dir = {}
    for i = info.linedefined, info.lastlinedefined do
      table.insert(root_dir, fileContent[i])
    end

    local description = table.concat(root_dir, '\n')
    return string.gsub(description, '.*function', 'function')
  elseif type(v) ~= 'string' then
    return vim.inspect(v)
  end

  return v
end

function M.create_tmpdir(closure)
  local tempdir = os.getenv 'DOCGEN_TEMPDIR' or vim.loop.fs_mkdtemp '/tmp/nvim-lsp.XXXXXX'
  local result = closure(tempdir)

  if not os.getenv 'DOCGEN_TEMPDIR' then
    os.execute('rm -rf ' .. tempdir)
  end

  return result
end

function M.write_file(filename, str)
  local writer = io.open(filename, 'w')
  writer:write(str)
  writer:close()
end

function M.read_json(path)
  local h = io.open(path)
  local s = h:read '*a'
  io.close(h)
  return vim.fn.json_decode(s)
end

function M.read_remote_json(module, package_json)
  return M.create_tmpdir(function(tempdir)
    local package_json_name = util.path.join(tempdir, module .. '.package.json')
    local args = os.getenv 'DOCGEN_DEBUG' and { '-vs' } or {}

    if not util.path.is_file(package_json_name) then
      os.execute(string.format('curl %s -L -o %q %q', table.concat(args, ' '), package_json_name, package_json))
    end

    if util.path.is_file(package_json_name) then
      return M.read_json(package_json_name)
    end

    return nil
  end)
end

function M.tbl_map_keys_sorted(fn, tbl)
  local result = {}
  local keys = vim.tbl_keys(tbl)
  table.sort(keys)

  for _, k in ipairs(keys) do
    local v = tbl[k]
    table.insert(result, fn(v, k))
  end

  return result
end

function M.render(tree)
  local function render_node(node, lines)
    if type(node) == 'string' then
      table.insert(lines, node)
    elseif type(node) == 'table' then
      if type(node[1]) == 'function' then
        local fn, props, children = unpack(node)
        local inner = children and M.render(children) or ''
        local result = fn(props, inner)

        if type(result) == 'table' then
          lines = render_node(result, lines)
        else
          table.insert(lines, result)
        end
      else
        for _, n in ipairs(node) do
          lines = render_node(n, lines)
        end
      end
    end

    return lines
  end

  return table.concat(render_node(tree, {}), '')
end

return M
