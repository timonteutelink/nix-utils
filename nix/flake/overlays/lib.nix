localFlake:
{ config, ... }: {
  flake.overlays.lib = final: prev: {
    lib = prev.lib // {
      nix-utils = config.flake.lib;
    };
  };
}
