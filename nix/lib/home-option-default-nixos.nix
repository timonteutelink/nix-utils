{ lib, ... }:
let
  homeOptionDefaultNixos =
    { description ? "No description provided"
    , inputs ? { }
    , mirror ? null
    , type ? null
    }: (
      let
        osConfig =
          if (builtins.hasAttr "osConfig" inputs && inputs.osConfig != null)
          then inputs.osConfig else null;

        optionDefault = (import ./get-nested-attr.nix { inherit lib; }).get-nested-attr (lib.splitString "." mirror) osConfig;
      in
      lib.mkOption {
        inherit description type;
        default = optionDefault;
      }
    );
in
{
  inherit homeOptionDefaultNixos;
}
