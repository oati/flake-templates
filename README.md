# flake-templates

Nix flake templates for my personal projects.

## Initialization

Some templates require initialization before use.

### rust

```sh
nix shell nixpkgs#cargo
cargo init
cargo generate-lockfile
nix develop
```

### python

```sh
nix develop
uv init
uv lock
```
