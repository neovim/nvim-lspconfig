local omnisharp_mono_config = require 'lspconfig.server_configurations.omnisharp'

function table.clone(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[table.clone(k)] = table.clone(v) end
    return res
end

-- Currently they are the same, and we want to avoid redundant code.
return table.clone(omnisharp_mono_config)
