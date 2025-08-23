localFlake:
{ config, inputs, ... }: {
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem = { system, self', ... }:
    let
    in
    {
      devenv.shells.default = {
        name = "Nix Utils";

        languages = { };

        pre-commit = {
          settings = { };
          hooks = { nixpkgs-fmt.enable = true; };
        };

        enterShell = ''
          echo 'Biep Boop'
        '';
      };
    };
}
