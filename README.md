# flake-templates

Nix flake templates for my personal projects.

## Initialization

Some templates require initialization before use.

### rust

```sh
nix shell nixpkgs#cargo
cargo init
cargo generate-lockfile
```

### python

```sh
nix shell nixpkgs#python3 nixpkgs#uv
uv init --bare
uv lock
```

### python-with-package

```sh
nix shell nixpkgs#python3 nixpkgs#uv
uv init --bare --package
uv lock
```
