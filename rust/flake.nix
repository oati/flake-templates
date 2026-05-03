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
    revision = inputs.self.shortRev or inputs.self.dirtyShortRev;
  in {
    packages =
      lib.mapAttrs (system: pkgs: rec {
        default = my-package;

        my-package = pkgs.rustPlatform.buildRustPackage {
          pname = "";
          version = revision;
          src = ./.;
          cargoLock = {
            lockFile = ./Cargo.lock;
            allowBuiltinFetchGit = true;
          };

          meta.mainProgram = "";
        };
      })
      pkgsFor;

    devShells =
      lib.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [
            inputs.self.packages.${system}.my-package
          ];

          packages = with pkgs; [
            # language server
            rust-analyzer
            clippy
          ];
        };
      })
      pkgsFor;
  };
}
