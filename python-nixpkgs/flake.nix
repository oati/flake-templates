{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    eachSystem = lib.genAttrs lib.systems.flakeExposed;
    pkgsFor = eachSystem (system:
      import inputs.nixpkgs {
        localSystem.system = system;
      });
  in {
    devShells =
      lib.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          packages = [
            (pkgs.python3.withPackages (p: [
              # language server
              p.ruff
              p.ty
            ]))
          ];
        };
      })
      pkgsFor;
  };
}
