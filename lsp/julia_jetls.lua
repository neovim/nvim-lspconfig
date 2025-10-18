---@brief
---
--- https://github.com/aviatesk/JETLS.jl
---
--- `JETLS` is a new language server for Julia

--- Define the directory where julia environments are usually located
local julia_envs = os.getenv('HOME') .. '.julia/environments'

return {
  cmd = {
    'julia',
    '--startup-file=no',
    '--history-file=no',
    '--project=" .. julia_envs.. "/JETLS.jl',
    julia_envs .. '/JETLS.jl/runserver.jl',
  },
  filetypes = { 'julia' },
  root_markers = { 'Project.toml', 'JuliaProject.toml' },
  docs = {
    description = [[
A new language server for Julia.

To install the Julia JETLS.jl language server, please follow the installation instructions given by the project.


```sh
cd $HOME/julia/environments
git clone git@github.com:aviatesk/JETLS.jl.git
cd JETLS.jl
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```
    ]],
  },
}
