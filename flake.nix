{
  outputs = inputs: {
    templates = {
      base = {
        description = "basic devshell";
        path = ./base;
      };

      base-with-package = {
        description = "basic devshell and package";
        path = ./base-with-package;
      };

      typst = {
        description = "typst devshell";
        path = ./typst;
      };

      typst-document = {
        description = "typst devshell and document package";
        path = ./typst-document;
      };

      rust = {
        description = "rust devshell and package";
        path = ./rust;
      };

      python = {
        description = "python devshell using uv";
        path = ./python;
      };

      python-nixpkgs = {
        description = "python devshell using nixpkgs";
        path = ./python-nixpkgs;
      };
    };
  };
}
