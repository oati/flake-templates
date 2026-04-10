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

      python = {
        description = "python project";
        path = ./python;
      };

      python-marimo = {
        description = "python project with marimo";
        path = ./python-marimo;
      };
    };
  };
}
