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
  in {
    devShells =
      lib.mapAttrs (system: pkgs: let
        python = pkgs.python3;

        pythonPackageSet =
          (pkgs.callPackage inputs.pyproject-nix.build.packages {
            inherit python;
          }).overrideScope (lib.composeManyExtensions [
            workspace-overlay
          ]);

        pythonEnv = pythonPackageSet.mkVirtualEnv "python-env" workspace.deps.all;
      in {
        default = pkgs.mkShell {
          packages = [
            pkgs.uv
            pythonEnv

            # language server
            pkgs.python3Packages.ruff
            pkgs.python3Packages.ty
          ];
        };
      })
      pkgsFor;
  };
}
