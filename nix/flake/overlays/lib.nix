localFlake:
{ config, ... }: {
  flake.overlays.lib = final: prev: {
    lib = prev.lib // {
      timon = config.flake.lib;
    };
  };
}
