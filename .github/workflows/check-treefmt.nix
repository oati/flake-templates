name: Check treefmt

on:
  push:
    paths:
      # Set this to the directory of the template
      - treefmt/**
      - .github/workflows/check-treefmt.yml
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: cachix/install-nix-action@v23
        with:
          extra_nix_config: |
            access-tokens = github.com=${{ secrets.GITHUB_TOKEN }}

      - uses: actions/checkout@v4
        with:
          path: ./tmp

      - run: nix flake new -t ./tmp#treefmt ./work
      - name: Prepare the project
        working-directory: work
        run: |
          git init
          git add .

      - run: nix fmt "$PWD"
        working-directory: work

      - run: nix flake check --print-build-logs
        working-directory: work