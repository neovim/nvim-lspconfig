

-- Define the directory where julia environments are located
local julia_envs = os.getenv("JULIA_ENVS") or (os.getenv("HOME") .. "julia/environments")

return {
  cmd = {
        "julia",
        "--startup-file=no",
        "--history-file=no",
        "--project=" .. julia_envs.. "/JETLS.jl",
        julia_envs .. "/JETLS.jl/runserver.jl",
  },
  filetypes = {"julia"},
  root_markers = { "Project.toml", "JuliaProject.toml" },
  docs = {
    description = [[
https://github.com/aviatesk/JETLS.jl

JETLS.jl can be installed by cloning the repository, instantiating it, and compiling the language serevr with npm:

```sh
cd $HOME/julia/environments
git clone git@github.com:aviatesk/JETLS.jl.git
cd JETLS.jl
julia --project=. -e 'using Pkg; Pkg.instantiate()'
npm install
```

Complete installation instructions are given on the project page on github: https://github.com/aviatesk/JETLS

To update an existing installation, use the following commands:
```sh 
cd $HOME/julia/environments
git pull
julia --project=. -e 'using Pkg; Pkg.update()' 
```

    ]]
  }
}
