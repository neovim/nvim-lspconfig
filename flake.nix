{
  description = "Quickstart configurations for the Nvim LSP client";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        devShell = with pkgs; mkShell {
          buildInputs = [
            stylua
            luaPackages.luacheck
            luajitPackages.vusted
            selene
          ];
        };
      }
    );
}
