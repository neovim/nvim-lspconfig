{
  description = "Quickstart configurations for the Nvim LSP client";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      forAllSystems = function: nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ] (system: function nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        default = with pkgs; mkShell {
          packages = [
            stylua
            luaPackages.luacheck
            luajitPackages.vusted
            selene
          ];
        };
      });
    };
}
