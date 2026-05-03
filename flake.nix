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
        description = "typst project";
        path = ./typst;
      };

      typst-document = {
        description = "typst document with package";
        path = ./typst-document;
      };

      rust = {
        description = "rust project";
        path = ./rust;
      };

      python = {
        description = "python project";
        path = ./python;
      };

      python-with-package = {
        description = "python project with package";
        path = ./python-with-package;
      };

      python-nixpkgs = {
        description = "python project using nixpkgs";
        path = ./python-nixpkgs;
      };
    };
  };
}
