{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    press.url = "github:RossSmyth/press";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    eachSystem = lib.genAttrs lib.systems.flakeExposed;
    pkgsFor = eachSystem (system:
      import inputs.nixpkgs {
        localSystem.system = system;
        overlays = [inputs.press.overlays.default];
      });
    revision = inputs.self.shortRev or inputs.self.dirtyShortRev or "";
  in {
    packages =
      lib.mapAttrs (system: pkgs: rec {
        default = my-document;

        my-document = pkgs.buildTypstDocument {
          pname = "my-document";
          version = revision;
          src = ./.;

          file = "main.typ";

          typstEnv = p: [
          ];

          fonts = [
          ];
        };
      })
      pkgsFor;

    devShells =
      lib.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          inputsFrom = [
            inputs.self.packages.${system}.default
          ];

          packages = [
            # language server
            pkgs.tinymist
          ];
        };
      })
      pkgsFor;
  };
}
