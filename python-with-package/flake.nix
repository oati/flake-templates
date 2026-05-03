{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    eachSystem = lib.genAttrs lib.systems.flakeExposed;
    pkgsFor = eachSystem (system:
      import inputs.nixpkgs {
        localSystem.system = system;
      });

    workspace = inputs.uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};
    workspace-overlay = workspace.mkPyprojectOverlay {sourcePreference = "wheel";};

    pythonPackageSetFor = lib.mapAttrs (system: pkgs: let
      python = pkgs.python3;
    in
      (pkgs.callPackage inputs.pyproject-nix.build.packages {
        inherit python;
      }).overrideScope (lib.composeManyExtensions [
        inputs.pyproject-build-systems.overlays.wheel
        workspace-overlay
      ]))
    pkgsFor;
  in {
    packages =
      lib.mapAttrs (system: pkgs: let
        inherit (pkgs.callPackage inputs.pyproject-nix.build.util {}) mkApplication;
      in rec {
        default = my-package;

        my-package = mkApplication {
          venv = pythonPackageSetFor.${system}.mkVirtualEnv "python-package-env" workspace.deps.default;
          package = pythonPackageSetFor.${system}.my-package;
        };
      })
      pkgsFor;

    devShells =
      lib.mapAttrs (system: pkgs: let
        pythonEnv = pythonPackageSetFor.${system}.mkVirtualEnv "python-env" workspace.deps.all;
      in {
        default = pkgs.mkShell {
          inputsFrom = [
            inputs.self.packages.${system}.my-package
          ];

          packages = with pkgs; [
            uv
            pythonEnv

            # language server
            python3Packages.ruff
            python3Packages.ty
          ];
        };
      })
      pkgsFor;
  };
}
