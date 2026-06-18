{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      eachSystem = lib.genAttrs lib.systems.flakeExposed;
      pkgsFor = eachSystem (
        system:
        import inputs.nixpkgs {
          localSystem.system = system;
        }
      );
    in
    {
      devShells = lib.mapAttrs (system: pkgs: {
        default =
          let
            python = pkgs.python3;
          in
          pkgs.mkShell {
            packages = [
              pkgs.uv
              python

              # language server
              pkgs.python3Packages.ruff
              pkgs.python3Packages.ty
            ];

            env = {
              UV_PYTHON = lib.getExe python;
              UV_PYTHON_DOWNLOADS = "never";

              LD_LIBRARY_PATH = inputs.nixpkgs.lib.makeLibraryPath [ ];
            };

            shellHook = ''
              uv sync --frozen &&
              source .venv/bin/activate
            '';
          };
      }) pkgsFor;
    };
}
