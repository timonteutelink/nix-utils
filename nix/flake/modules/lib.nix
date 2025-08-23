localFlake:
{ inputs, ... }: {
  flake.lib = localFlake.withSystem "x86_64-linux" ({ config, pkgs, system, ... }:
    let
      importWithLib = path: (import path { inherit (pkgs) lib; });

      import-files = (importWithLib ./../../lib/import-files.nix).import-files;
      aggregate-objects = (importWithLib ./../../lib/aggregate-objects.nix).aggregate-objects;

      libFiles = import-files {
        path = ./../../lib;
        recursive = true;
      };

      libModules = pkgs.lib.lists.forEach libFiles importWithLib;
      timonLib = aggregate-objects libModules;
    in
    timonLib);
}
