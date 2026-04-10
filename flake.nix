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
    };
  };
}
