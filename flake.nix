{
  outputs = inputs: {
    templates = {
      base = {
        description = "flake boilerplate for devshell";
        path = ./base;
      };

      base-with-package = {
        description = "flake boilerplate for devshell and package";
        path = ./base-with-package;
      };

      typst = {
        description = "typst project";
        path = ./typst;
      };

      rust = {
        description = "rust project";
        path = ./rust;
      };

      python = {
        description = "python project";
        path = ./python;
      };

      python-nixpkgs = {
        description = "python project using nixpkgs";
        path = ./python-nixpkgs;
      };
    };
  };
}
